# Introduction

The **Fine-tuned Surreal-4o Model for SurrealQL Queries** project harnesses advanced machine learning to generate precise SurrealQL queries from structured prompts. This project is organized into three key syntax formats:

1. **Data Models**
2. **Functions**
3. **Statements**

Each of these folders contains comprehensive datasets, with 1,000 examples per version, designed to train the model effectively. For example, in the `statements/select` directory, you'll find JSONL-formatted datasets that include system prompts, user messages requesting queries, and the corresponding SurrealQL query outputs.

A critical component of this project is the SurrealQL schema, which ensures the generated queries are accurately structured. To integrate the schema into every system prompt, a Python script is provided:

```bash
python3 inject_schema.py ./statements/surreal-deal-store-min.surql ./statements/select/01-base.jsonl
```

- **First Argument:** Path to the SurrealQL schema (`./statements/surreal-deal-store-min.surql`)
- **Second Argument:** Path to the base JSONL dataset containing a "system_message" placeholder (`./statements/select/01-base.jsonl`)

This setup guarantees that each generated query aligns perfectly with the defined schema, enhancing the model's reliability and performance.