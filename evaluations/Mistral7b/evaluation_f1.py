import sys
import argparse
import multiprocessing as mp
import csv
from func_timeout import func_timeout, FunctionTimedOut
from evaluation_utils import (
    load_jsonl,
    execute_sql,
    package_sqls,
    sort_results,
    print_data,
)


def calculate_row_match(predicted_row, ground_truth_row):
    """
    Calculate the matching percentage for a single row.

    Args:
    predicted_row (tuple): The predicted row values.
    ground_truth_row (tuple): The actual row values from ground truth.

    Returns:
    float: The match percentage (0 to 1 scale).
    """
    total_columns = len(ground_truth_row)
    matches = 0
    element_in_pred_only = 0
    element_in_truth_only = 0
    for pred_val in predicted_row:
        if pred_val in ground_truth_row:
            matches += 1
        else:
            element_in_pred_only += 1
    for truth_val in ground_truth_row:
        if truth_val not in predicted_row:
            element_in_truth_only += 1
    match_percentage = matches / total_columns
    pred_only_percentage = element_in_pred_only / total_columns
    truth_only_percentage = element_in_truth_only / total_columns
    #return match_percentage, pred_only_percentage, truth_only_percentage
    return matches, element_in_pred_only, element_in_truth_only


from collections import defaultdict

def calculate_f1_score(predicted, ground_truth, return_details=False):
    if not predicted and not ground_truth:
        if return_details:
            return 1.0, 0, 0, 0, 1.0, 1.0
        return 1.0

    # Group predicted and ground truth rows by idx
    pred_grouped = defaultdict(list)
    gt_grouped = defaultdict(list)

    for row in predicted:
        idx, *values = row
        pred_grouped[idx].append(tuple(values))

    for row in ground_truth:
        idx, *values = row
        gt_grouped[idx].append(tuple(values))

    total_tp, total_fp, total_fn = 0, 0, 0

    # Union of all indices
    all_indices = set(pred_grouped.keys()) | set(gt_grouped.keys())

    for idx in all_indices:
        pred_rows = pred_grouped.get(idx, [])
        gt_rows = gt_grouped.get(idx, [])

        match_scores = []
        pred_only_scores = []
        truth_only_scores = []

        # Match predicted rows to ground truth rows by index
        for i, gt_row in enumerate(gt_rows):
            if i >= len(pred_rows):
                match_scores.append(0)
                truth_only_scores.append(1)
                continue

            pred_row = pred_rows[i]
            match_score, pred_only_score, truth_only_score = calculate_row_match(pred_row, gt_row)

            match_scores.append(match_score)
            pred_only_scores.append(pred_only_score)
            truth_only_scores.append(truth_only_score)

        # Handle extra predicted rows
        for i in range(len(pred_rows) - len(gt_rows)):
            match_scores.append(0)
            pred_only_scores.append(1)
            truth_only_scores.append(0)

        total_tp += sum(match_scores)
        total_fp += sum(pred_only_scores)
        total_fn += sum(truth_only_scores)

    # Final precision, recall, F1
    precision = total_tp / (total_tp + total_fp) if (total_tp + total_fp) > 0 else 0
    recall = total_tp / (total_tp + total_fn) if (total_tp + total_fn) > 0 else 0
    f1_score = 2 * precision * recall / (precision + recall) if (precision + recall) > 0 else 0

    if return_details:
        return f1_score, total_tp, total_fp, total_fn, precision, recall
    return f1_score




def result_callback(result):
    exec_result.append(result)


def execute_model(predicted_sql, ground_truth, db_place, idx, meta_time_out, sql_dialect):
    try:
        res = func_timeout(
            meta_time_out,
            execute_sql,
            args=(predicted_sql, ground_truth, db_place, sql_dialect, calculate_f1_score, idx),
        )
        f1, tp, fp, fn, precision, recall = res

    except (KeyboardInterrupt, FunctionTimedOut):
        sys.exit(0)
    except Exception as e:
        f1, tp, fp, fn, precision, recall = 0, 0, 0, 0, 0, 0

    result = {
        "sql_idx": idx,
        "predicted_sql": predicted_sql,
        "ground_truth_sql": ground_truth,
        "f1": f1,
        "tp": tp,
        "fp": fp,
        "fn": fn,
        "precision": precision,
        "recall": recall,
    }
    return result



def run_sqls_parallel(
    sqls, db_places, num_cpus=1, meta_time_out=30.0, sql_dialect="SQLite"
):
    pool = mp.Pool(processes=num_cpus)
    for i, sql_pair in enumerate(sqls):

        predicted_sql, ground_truth = sql_pair
        pool.apply_async(
            execute_model,
            args=(
                predicted_sql,
                ground_truth,
                db_places[i],
                i,
                meta_time_out,
                sql_dialect,
            ),
            callback=result_callback,
        )
    pool.close()
    pool.join()


def compute_f1_by_diff(exec_results, diff_json_path):
    num_queries = len(exec_results)
    results = [res["f1"] for res in exec_results]
    contents = load_jsonl(diff_json_path)
    simple_results, moderate_results, challenging_results = [], [], []

    for i, content in enumerate(contents):
        if content["difficulty"] == "simple":
            simple_results.append(exec_results[i])

        if content["difficulty"] == "moderate":
            moderate_results.append(exec_results[i])

        if content["difficulty"] == "challenging":
            try:
                challenging_results.append(exec_results[i])
            except:
                print(i)

    simple_f1 = sum([res["f1"] for res in simple_results]) / len(simple_results) * 100
    try:
      moderate_f1 = (sum([res["f1"] for res in moderate_results]) / len(moderate_results) * 100)
      challenging_f1 = (sum([res["f1"] for res in challenging_results])/ len(challenging_results)* 100)
    except:
      moderate_f1 = 0
      challenging_f1 = 0
      
    all_f1 = sum(results) / num_queries * 100
    count_lists = [
        len(simple_results),
        len(moderate_results),
        len(challenging_results),
        num_queries,
    ]
    return (
        simple_f1,
        moderate_f1,
        challenging_f1,
        all_f1,
        count_lists,
    )

def write_detailed_csv(results, output_path="detailed_results.csv"):
    fieldnames = [
        "sql_idx", "predicted_sql", "ground_truth_sql",
        "tp", "fp", "fn", "precision", "recall", "f1"
    ]
    with open(output_path, "w", newline='', encoding='utf-8') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        for res in results:
            writer.writerow(res)


if __name__ == "__main__":
    args_parser = argparse.ArgumentParser()
    args_parser.add_argument(
        "--predicted_sql_path", type=str, required=True, default=""
    )
    args_parser.add_argument("--ground_truth_path", type=str, required=True, default="")
    args_parser.add_argument("--db_root_path", type=str, required=True, default="")
    args_parser.add_argument("--num_cpus", type=int, default=1)
    args_parser.add_argument("--meta_time_out", type=float, default=30.0)
    args_parser.add_argument("--diff_json_path", type=str, default="")
    args_parser.add_argument("--sql_dialect", type=str, default="SQLite")
    args_parser.add_argument("--output_log_path", type=str, default="SQLite")
    args = args_parser.parse_args()
    exec_result = []

    pred_queries, db_paths = package_sqls(
        args.predicted_sql_path,
        args.db_root_path,
        mode='pred'
    )
    # generate ground truth sqls:
    gt_queries, db_paths_gt = package_sqls(
        args.ground_truth_path,
        args.db_root_path,
        mode="gt",
    )

    query_pairs = list(zip(pred_queries, gt_queries))

    run_sqls_parallel(
        query_pairs,
        db_places=db_paths_gt,
        num_cpus=args.num_cpus,
        meta_time_out=args.meta_time_out,
        sql_dialect=args.sql_dialect,
    )
    exec_result = sort_results(exec_result)

    print("start calculate Soft F1")
    simple_acc, moderate_acc, challenging_acc, acc, count_lists = compute_f1_by_diff(
        exec_result, args.diff_json_path
    )
    score_lists = [simple_acc, moderate_acc, challenging_acc, acc]
    print_data(score_lists, count_lists,metric='Soft-F1',result_log_file=args.output_log_path)
    print(
        "==========================================================================================="
    )
    print(f"Finished EX evaluation for {args.sql_dialect} on Mini Dev set")
    print("\n\n")

    detailed_log_path = args.output_log_path.replace(".txt", "_detailed.csv")

    write_detailed_csv(exec_result, output_path=detailed_log_path)
