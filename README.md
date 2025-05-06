```markdown
# Benchmarking SQL-Generating LLMs: Metrics, Mistakes, and Meaning

This project evaluates and compares **CodeLlama** and **Mistral** models for SQL generation from natural language using the **Chinook** and **Spider** databases. It also explores **RAG (Retrieval-Augmented Generation)** and **LoRA fine-tuning** techniques to enhance model performance.

---

## Repository Structure


text-to-sql/
├── datasets/                   
│   ├── chinook/
│   └── spider/
├── evaluations/     
├── knowledge/             
├── models/         
├── notebooks/       
├── prompts/          
├── results/             
├── requirements_cleaned.txt        
└── README.md


## How to Run (Google Colab)

> You can run each notebook step-by-step in Colab using the datasets and saved models in Google Drive.

### 1. **CodeLlama on Chinook Dataset**
- `notebooks/CodeLlama_Chinook.ipynb`
- Tasks:
  - RAG prompt building
  - SQL generation
  - Execution and Exact Match evaluation
  - Fine-tuning with LoRA
  - Post-finetune evaluation

### 2. **Mistral on Chinook Dataset**
- `notebooks/Mistral_Chinook_Execution.ipynb`
- Tasks:
  - SQL generation (w/ and w/o RAG)
  - Comparison on custom 30-question test set

### 3. **Mistral on Spider Subset**
- `notebooks/Mistral_Spider_Execution.ipynb`
- Tasks:
  - Run inference on Spider subset
  - Evaluate model responses

---

## Evaluation Metrics

Each generated query is evaluated using:
- **Exact Match Accuracy** — full string match with the gold SQL.
- ⚙**Execution Match Accuracy** — same result as the gold query when run on the DB.

Evaluation results are saved in:


text-to-sql/
├── results/
│   ├── mistral_rag_spider_evaluation_results.csv
|   ├── chinook_eval_results_finetuned.json
|   └── ...


---

## Highlights

* Fine-tuned `CodeLlama-7B-Instruct` using LoRA for Chinook SQL generation.
* RAG enhancement with MiniLM-based schema retrieval.
* Side-by-side evaluation of raw vs RAG vs fine-tuned model outputs.
* Clean modular scripts and JSON-based experiment tracking.

---

## Future Improvements

* Add support for GPT-4 and SQLCoder.
* Expand evaluation to full Spider dataset.
* Experiment with retrieval fine-tuning.

---

## Acknowledgements

Spider dataset
@inproceedings{Yu&al.18c,
  title     = {Spider: A Large-Scale Human-Labeled Dataset for Complex and Cross-Domain Semantic Parsing and Text-to-SQL Task},
  author    = {Tao Yu and Rui Zhang and Kai Yang and Michihiro Yasunaga and Dongxu Wang and Zifan Li and James Ma and Irene Li and Qingning Yao and Shanelle Roman and Zilin Zhang and Dragomir Radev}
  booktitle = "Proceedings of the 2018 Conference on Empirical Methods in Natural Language Processing",
  address   = "Brussels, Belgium",
  publisher = "Association for Computational Linguistics",
  year      = 2018
}

Bird bench Evaluation
@article{li2024can,
  title={Can llm already serve as a database interface? a big bench for large-scale database grounded text-to-sqls},
  author={Li, Jinyang and Hui, Binyuan and Qu, Ge and Yang, Jiaxi and Li, Binhua and Li, Bowen and Wang, Bailin and Qin, Bowen and Geng, Ruiying and Huo, Nan and others},
  journal={Advances in Neural Information Processing Systems},
  volume={36},
  year={2024}
}

Chinook database
@misc{chinook-database,
  author       = {Leonardo Rocha},
  title        = {Chinook Database},
  year         = {2013},
  howpublished = {\url{https://github.com/lerocha/chinook-database}},
  note         = {GitHub repository}
}

---

## Authors

**Shamanth Kodipura Mahesh**
[GitHub](https://github.com/Shamanth-KM)

**Raees Ahmed Faiz Mohammed Parkar**
[GitHub](https://github.com/raeesp97)

**Arnav Dhairyasheel Mohite**
[GitHub](https://github.com/ArnavMohite)
