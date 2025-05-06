import sqlite3
import json
import re
import os
import argparse
import pandas as pd

def normalize(sql):
    sql = sql.strip().lower()
    sql = re.sub(r"\s+", " ", sql)  # collapse whitespace
    sql = sql.replace(';','').replace(' ,',',')
    return sql

def evaluate_sql_predictions(gen_sql_path, ground_truth_path, base_db_dir, output_csv_path):
    # Load data
    with open(gen_sql_path) as f:
        gen_data = json.load(f)

    with open(ground_truth_path) as f:
        gt_data = json.load(f)

    correct_exact = 0
    correct_exec = 0
    results = []
    db_connections = {}

    for gen, gt in zip(gen_data, gt_data):
        pred = normalize(gen["clean_sql_extracted"])
        gold = normalize(gt["gold_sql"])
        db_id = gt["db_id"]

        db_path = os.path.join(base_db_dir, db_id, f"{db_id}.sqlite")

        # Open or reuse connection
        if db_id not in db_connections:
            if not os.path.exists(db_path):
                print(f"[WARNING] Database not found: {db_path}")
                continue
            db_connections[db_id] = sqlite3.connect(db_path)
        cursor = db_connections[db_id].cursor()

        exact_match = pred == gold
        exec_match = False

        try:
            cursor.execute(pred)
            gen_result = cursor.fetchall()

            cursor.execute(gold)
            gt_result = cursor.fetchall()

            exec_match = gen_result == gt_result
        except Exception as e:
            exec_match = False
            print(f"[ERROR] Execution failed for DB {db_id}: {e}")

        correct_exact += int(exact_match)
        correct_exec += int(exec_match)

        results.append({
            "db_id": db_id,
            "ground_truth_sql": gt["gold_sql"],
            "generated_sql": gen["clean_sql_extracted"],
            "exact_match": exact_match,
            "execution_match": exec_match
        })

    for conn in db_connections.values():
        conn.close()

    df = pd.DataFrame(results)
    df.to_csv(output_csv_path, index=False)

    total = len(gt_data)
    print("\Evaluation Complete")
    print(f"Exact Match Accuracy:    {correct_exact / total * 100:.2f}%")
    print(f"Execution Match Accuracy: {correct_exec / total * 100:.2f}%")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Evaluate SQL generation results.")
    parser.add_argument("--gen_sql_path", type=str, required=True, help="Path to generated SQL JSON file.")
    parser.add_argument("--ground_truth_path", type=str, required=True, help="Path to ground truth SQL JSON file.")
    parser.add_argument("--base_db_dir", type=str, required=True, help="Base directory containing the SQLite DBs.")
    parser.add_argument("--output_csv_path", type=str, required=True, help="Path to output evaluation CSV file.")

    args = parser.parse_args()

    evaluate_sql_predictions(
        gen_sql_path=args.gen_sql_path,
        ground_truth_path=args.ground_truth_path,
        base_db_dir=args.base_db_dir,
        output_csv_path=args.output_csv_path
    )