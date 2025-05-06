# -*- coding: utf-8 -*-

import sys
sys.path.append('/content/drive/MyDrive/text2SQL')

import os
import json
import pandas as pd
from models.mistral7b.model_loader import load_model_and_tokenizer
from models.mistral7b.sql_generator import generate_sql, extract_sql
import faiss
import numpy as np
from sentence_transformers import SentenceTransformer
import ast

with open("/content/drive/MyDrive/text2SQL/knowledge/spider_knowledge_base.txt", 'r', encoding='utf-8') as file:
    rag_kb = file.read()

retriever_model = SentenceTransformer("all-MiniLM-L6-v2")
corpus_embeddings = retriever_model.encode(rag_kb, convert_to_numpy=True)

if len(corpus_embeddings.shape) == 1:
    corpus_embeddings = corpus_embeddings.reshape(1, -1)
    
index = faiss.IndexFlatL2(corpus_embeddings.shape[1])
index.add(corpus_embeddings)

def retrieve_context(question, top_k=3):
    query_embedding = retriever_model.encode([question], convert_to_numpy=True)
    D, I = index.search(query_embedding, top_k)
    return [rag_kb[i] for i in I[0]]

def spider_run_rag_experiment(tokenizer, model):
    # Load model
    #tokenizer, model = load_model_and_tokenizer()

    # Load baseline prompts
    with open("/content/drive/MyDrive/text2SQL/prompts/Mistral7b/spider_prompts.json", "r") as f:
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

        context = retrieve_context(prompt_text,3)

        # Create prompt for model
        full_prompt = f"Database Schema {schema}, ###Context {context} Based on the provided database schema information, {prompt_text}\n ### SQL:"

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
            partial_path = "/content/drive/MyDrive/text2SQL/results/partial_mistral_rag_spider_exp_res.csv"
            pd.DataFrame(results).to_csv(partial_path, index=False)
            print(f"Saved partial results at {idx+1} prompts to {partial_path}")

    # Save results to CSV
    os.makedirs("results", exist_ok=True)
    output_path = "/content/drive/MyDrive/text2SQL/results/mistral_rag_spider_exp_res.csv"
    pd.DataFrame(results).to_csv(output_path, index=False)

    print(f"Experiment completed! Results saved at {output_path}")

if __name__ == "__main__":
    tokenizer, model = load_model_and_tokenizer()
    spider_run_rag_experiment(tokenizer,model)