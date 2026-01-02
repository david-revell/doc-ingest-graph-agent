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

## Configuration
Environment variables live in `.env` at the repo root. Start from `.env.example`.

Required:
- `NEO4J_URI`
- `NEO4J_PASSWORD`
- `OPENAI_API_KEY`

Optional:
- `NEO4J_USERNAME` (defaults to `neo4j`)
- `NEO4J_DEBUG` (set to `1` to enable Neo4j debug prints)

## Project layout
- `src/` : core source code
- `scripts/` : small utilities (like connection tests)
- `docs/` : lightweight documentation

## Models
This project uses two kinds of models:

1) Chat model (agent)
   - Default: `gpt-5-nano`
   - Location: `src/chatbot_framework.py` (`build_agent` call)
   - Change by editing the `llm_model` argument

2) Embedding model (retrieval + ingestion)
   - Default: `text-embedding-3-small` (cost-saving choice)
   - Locations: `src/process_graph.py`, `src/documentation_model.py`, `src/pdf_processor.py`
   - Change to `text-embedding-3-large` if you want higher quality

## Useful Cypher
Show a sample of the corpus -> document -> page chain:

```cypher
MATCH (c:CORPUS)-[:CONTAINS]->(d:DOCUMENT)-[:CONTAINS]->(p:PAGE)
RETURN c, d, p
LIMIT 25
```

## Status
The ingestion pipeline in `src/documentation_model.py` is partially implemented.
Stubs are still in place for summaries and best representation detection.
See `docs/DESIGN_STATUS.md` for a full gap list and ordered todo items.

Cost note: PRA PDFs in `data/` are image-heavy and need OCR/vision to process; that adds cost.
For a low-cost start, prefer text-extractable PDFs and run a small pilot first.

## Terminology
- Atomic fact: a minimal, standalone statement that can be verified from the page text without extra context.

## Cost baseline (early)
- Two ingestion runs on `CitiGroup_2025_Q2_earnings_call_transcript.pdf` each used 20,658 tokens.
- Working assumption: this personal project targets tens of pages, with headroom to scale later.
