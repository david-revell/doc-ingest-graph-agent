# Design And Status

This doc is a living snapshot of how the system is designed today, what works,
and what is missing. It is not a substitute for code comments or README usage.

## Purpose
- Provide a shared understanding of the data model and pipeline.
- Record known gaps and limitations, especially in ingestion.
- Keep a short, ordered todo list that reflects current priorities.

## Data Model (Neo4j)
Nodes:
- `CORPUS`: group of documents (e.g., a folder or dataset)
- `DOCUMENT`: a single PDF/document
- `PAGE`: a single page of a document
- `FACT`: extracted fact from a page (not yet implemented)

Relationships:
- `(:CORPUS)-[:CONTAINS]->(:DOCUMENT)`
- `(:DOCUMENT)-[:CONTAINS]->(:PAGE)`
- `(:PAGE)-[:CONTAINS]->(:FACT)` (planned)
- `(:FACT)-[:QUESTION]->(:PAGE)` (planned)

Key properties (current):
- `DOCUMENT.summary` (currently empty)
- `PAGE.text`, `PAGE.summary`, `PAGE.keywords`, `PAGE.embedding`
- `FACT.embedding` (planned)

## Pipeline Overview
1) Ingestion (PDF -> pages -> Neo4j)
2) Retrieval (Neo4j vector similarity over facts/pages)
3) Agent (tool-using chat interface)

## Current Status
Ingestion:
- Implemented: PDF text extraction, page screenshots, basic document/page nodes.
- Stubs: document summaries, best representation detection, fact generation,
  and fact embeddings (see `src/documentation_model.py`).

Retrieval:
- Implemented: `GraphProcessor.query_graph` with cosine similarity in Cypher.
- Implemented: wrappers (`Retrieved_fact`, `Retrieval_by_document`, `Retrieval_overall`).
- Optional: `compute_similarities` for FACT-FACT similarity (FACT nodes needed).

Agent:
- Implemented: `chatbot_framework.py` with tools for PRA + banks retrieval.
- Expects facts to exist in Neo4j to be useful.

## Known Gaps / Limitations
- No real fact extraction yet (stubs only).
- No page summaries/keywords/best representation yet.
- Ingestion uses OpenAI embeddings only where facts exist (currently none).
- No indexing setup or schema enforcement in Neo4j.

## TODO (Ordered)
1) Implement fact extraction to populate `FACT` and `QUESTION` nodes.
2) Implement page summaries and keyword extraction.
3) Implement page-level embeddings (optional, but useful for fallback retrieval).
4) Add Neo4j index/vector index setup for facts/pages.
5) Add basic ingestion validation report (counts, missing fields).

## Test TODOs
1) Agent check: `python src/chatbot_framework.py` and confirm tool calls work.

Notes:
- Retrieval and agent depend on FACT nodes; until fact extraction exists,
  agent responses will be thin or empty.

## Notes
- Keep this doc short and updated after every meaningful pipeline change.
