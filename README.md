# Document Ingestion and Knowledge Graph Agent

A clean-start repo focused on three stages:
1) Document ingestion
2) Knowledge graph storage (Neo4j)
3) Retrieval and agent interface

## Quick start
1) Copy `.env.example` to `.env` and fill values.
2) Install dependencies: `pip install -r requirements.txt`.
3) Test Neo4j connection: `python scripts/test_neo4j_connection.py`.
4) Ingest PDFs: `python scripts/ingest_folder.py --path "C:\\path\\to\\pdfs"`.
5) Run the agent: `python src/chatbot_framework.py`.

## Project layout
- `src/` : core source code
- `scripts/` : small utilities (like connection tests)
- `docs/` : lightweight documentation

## Useful Cypher
Show a sample of the corpus → document → page chain:

```cypher
MATCH (c:CORPUS)-[:CONTAINS]->(d:DOCUMENT)-[:CONTAINS]->(p:PAGE)
RETURN c, d, p
LIMIT 25
```

## Notes
- `.env` is loaded from the repo root by `src/DB_neo4j.py`.
- The ingestion pipeline in `src/documentation_model.py` is partially implemented and will be completed later.
