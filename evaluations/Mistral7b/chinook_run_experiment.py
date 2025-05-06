# -*- coding: utf-8 -*-

import sys
sys.path.append('/content/drive/MyDrive/text2SQL')

import os
import json
import pandas as pd
from models.mistral7b.model_loader import load_model_and_tokenizer
from models.mistral7b.sql_generator import generate_sql, extract_sql


def run_experiment(tokenizer, model):
    # Load model
    #tokenizer, model = load_model_and_tokenizer()

    # Load baseline prompts
    with open("/content/drive/MyDrive/text2SQL/prompts/Mistral7b/chinook_prompts.json", "r") as f:
        prompts = json.load(f)

    results = []

    total = len(prompts)

    SAVE_INTERVAL = 10   # Save after every 10 prompts
    os.makedirs("results", exist_ok=True)

    # Loop through prompts
    for idx, example in enumerate(prompts):
        prompt_text = example['question']
        db_id = example['db_id']
        gold_sql = example['gold_sql']
        schema = example['db_schema']

        # Create prompt for model
        full_prompt = f"Database Schema {schema}, Based on the provided database schema information, {prompt_text}\n ### SQL:"

        try:
            # Generate raw model output
            raw_output = generate_sql(full_prompt, model, tokenizer)

            # Extract clean SQL
            clean_sql = extract_sql(raw_output)

            results.append({
                "db_id": db_id,
                "natural_language_question": prompt_text,
                "gold_sql": gold_sql,
                "raw_model_output": raw_output,
                "clean_sql_extracted": clean_sql
            })

            print(f"Prompt {idx+1}/{total} completed")

        except Exception as e:
            print(f"Prompt {idx+1}/{total} failed : {e}")
            continue

        # Save partial results every SAVE_INTERVAL prompts
        if (idx + 1) % SAVE_INTERVAL == 0:
            partial_path = "/content/drive/MyDrive/text2SQL/results/partial_mistral_baseline_chinook_exp_res.csv"
            pd.DataFrame(results).to_csv(partial_path, index=False)
            print(f"Saved partial results at {idx+1} prompts to {partial_path}")

    # Save results to CSV
    os.makedirs("results", exist_ok=True)
    output_path = "/content/drive/MyDrive/text2SQL/results/mistral_baseline_chinook_exp_res.csv"
    pd.DataFrame(results).to_csv(output_path, index=False)

    print(f"Experiment completed! Results saved at {output_path}")

if __name__ == "__main__":
    tokenizer, model = load_model_and_tokenizer()
    run_experiment(tokenizer,model)