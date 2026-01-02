# Design And Status
**Document Ingestion and Knowledge Graph Agent**  
*docs/DESIGN_STATUS.md*  

---

## 1. Purpose

1.1 Provide a shared understanding of the data model and pipeline.  
1.2 Record known gaps and limitations, especially in ingestion.  
1.3 Keep a short, ordered todo list that reflects current priorities.  

## 2. Data Model (Neo4j)

2.1 Nodes:  
2.1.1 `CORPUS`: group of documents (e.g., a folder or dataset)  
2.1.2 `DOCUMENT`: a single PDF/document  
2.1.3 `PAGE`: a single page of a document  
2.1.4 `FACT`: extracted fact from a page  

2.2 Relationships:  
2.2.1 `(:CORPUS)-[:CONTAINS]->(:DOCUMENT)`  
2.2.2 `(:DOCUMENT)-[:CONTAINS]->(:PAGE)`  
2.2.3 `(:PAGE)-[:CONTAINS]->(:FACT)`  
2.2.4 `(:FACT)-[:QUESTION]->(:PAGE)`  

2.3 Key properties (current):  
2.3.1 `DOCUMENT.summary` (currently empty)  
2.3.2 `PAGE.text`, `PAGE.summary`, `PAGE.keywords`, `PAGE.embedding`  
2.3.3 `FACT.embedding`  

## 3. Pipeline Overview

3.1 Ingestion (PDF -> pages -> Neo4j)  
3.2 Retrieval (Neo4j vector similarity over facts/pages)  
3.3 Agent (tool-using chat interface)  

## 4. Current Status

4.1 Ingestion:  
4.1.1 Implemented: PDF text extraction, page screenshots, basic document/page nodes.  
4.1.2 Stubs (original, not implemented): document summaries and best representation detection (see `src/documentation_model.py`).  

4.2 Retrieval:  
4.2.1 Implemented: `GraphProcessor.query_graph` with cosine similarity in Cypher.  
4.2.2 Implemented: wrappers (`Retrieved_fact`, `Retrieval_by_document`, `Retrieval_overall`).  
4.2.3 Optional: `compute_similarities` for FACT-FACT similarity (FACT nodes needed).  

4.3 Agent:  
4.3.1 Implemented: `chatbot_framework.py` with tools for PRA + banks retrieval.  
4.3.2 Expects facts to exist in Neo4j to be useful.  

## 5. Known Gaps / Limitations

5.1 No page summaries/keywords/best representation yet.  
5.2 Ingestion uses OpenAI embeddings only where facts exist (facts now extracted for text pages).  
5.4 No indexing setup or schema enforcement in Neo4j.  
5.5 PRA PDFs in `data/` appear to be image-heavy or protected; text extraction is minimal. OCR or vision is required to process them properly.  
5.6 OCR/vision adds cost; current scope is cost-sensitive and should favor text-extractable PDFs.  

## 6. Workboard

6.1 Planned:  
*(Note: Labels: "Stubbed" = previously existing TODOs in code; "Nice-to-have" = ideas we added later.)*

6.1.1 Nice-to-have: add a basic ingestion validation report (via Cypher queries).
After stabilising ingestion and fact extraction, the next step is to add cheap, deterministic sanity checks before building further LLM-dependent features. This is not a UI or generated report, but a small set of Cypher queries run manually in Neo4j Browser to confirm ingestion quality (e.g. document/page/fact counts, pages with zero facts, facts with zero questions).  

Ideas:
- Count documents, pages, facts
- Find pages with zero facts
- Find facts with zero questions
- Simple per-page fact distribution

---

6.1.2 Nice-to-have: add Neo4j index / vector index setup for facts/pages.  
6.1.3 Nice-to-have: implement page-level embeddings (optional, but useful for fallback retrieval; see `_generate_page_embedding()` in `src/pdf_processor.py`).  
6.1.4 Nice-to-have: consider revising the fact-extraction prompt by removing the requirement to generate a specific number of questions per fact (currently "2-4").  
6.1.5 Nice-to-have: add a basic Streamlit demo UI (read-only).  
6.1.6 Stubbed: implement page summaries and keyword extraction (see `Document.generate_document_summaries()` in `src/documentation_model.py`).  
6.1.7 Stubbed (stretch): implement best representation detection for pages (see `Document.detect_best_representation()` in `src/documentation_model.py`).  
6.1.8 Nice-to-have (later): extend Streamlit UI with controls / richer interaction.

6.2 In Progress:  
6.2 Development: scoping a low-cost pilot.  

6.3 Done:  
6.3.1 Neo4j connection test passes.  
6.3.2 Basic ingestion run completes (document/page nodes created).  
6.3.3 Agent CLI runs and returns responses.  
6.3.4 Implement fact extraction to populate `FACT` and `QUESTION` nodes.  

## 7. Observations

7.1 Cost (early baseline): two ingestion runs on `CitiGroup_2025_Q2_earnings_call_transcript.pdf` each used 20,658 tokens.  
7.2 FACT -> QUESTION is 1-to-1 in practice for atomic facts (a single fact is a minimal, standalone statement).  
7.3 Scale assumption: design for tens of pages (personal project), with headroom to scale if needed. This favors low-cost text extraction before OCR/vision.  
7.4 Logging/progress: avoid misleading logs (e.g., embedding before facts exist). Prefer explicit per-page progress during extraction.  

## 8. Notes

8.1 Keep this doc short and updated after every meaningful pipeline change.
