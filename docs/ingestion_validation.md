# Ingestion Validation Notes

Short descriptions of each query in `docs/queries/ingestion_validation.cypher` and what "bad" looks like.

1) Counts + orphans: counts CORPUS, DOCUMENT, PAGE, FACT and checks relationship coverage. Bad: zero or unexpectedly low counts.
```cypher
MATCH (c:CORPUS)
OPTIONAL MATCH (c)-[:CONTAINS]->(d:DOCUMENT)
OPTIONAL MATCH (d)-[:CONTAINS]->(p:PAGE)
OPTIONAL MATCH (p)-[:CONTAINS]->(f:FACT)
RETURN count(DISTINCT c) AS corpora,
       count(DISTINCT d) AS documents,
       count(DISTINCT p) AS pages,
       count(DISTINCT f) AS facts;
```
2) Documents with zero pages: lists DOCUMENT nodes with no PAGE children. Bad: any rows returned.
```cypher
MATCH (d:DOCUMENT)
WHERE NOT (d)-[:CONTAINS]->(:PAGE)
RETURN d { .*, app_id: d.id } AS document
LIMIT 20;
```
3) Pages with zero facts: lists PAGE nodes with no FACT children. Bad: many rows returned or concentrated in specific documents.
```cypher
MATCH (p:PAGE)
WHERE NOT (p)-[:CONTAINS]->(:FACT)
RETURN p { .*, app_id: p.id } AS page
LIMIT 50;
```
4) Facts with zero questions: lists FACT nodes with no QUESTION relationship. Bad: any rows returned (if every fact should link to a question).
```cypher
MATCH (f:FACT)
WHERE NOT (f)-[:QUESTION]->(:PAGE)
RETURN f { .*, app_id: f.id } AS fact
LIMIT 50;
```
5) Page text missing/empty: lists PAGE nodes with null/empty text. Bad: any rows returned unless you expect image-only PDFs.
```cypher
MATCH (p:PAGE)
WHERE p.text IS NULL OR trim(p.text) = ""
RETURN p { .*, app_id: p.id } AS page
LIMIT 50;
```
6) Fact distribution per page: distribution table mapping fact_count -> pages (how many pages have N facts). Bad: lots of zeros or extreme outliers.
```cypher
MATCH (p:PAGE)
OPTIONAL MATCH (p)-[:CONTAINS]->(f:FACT)
WITH p, count(f) AS fact_count
RETURN fact_count, count(*) AS pages
ORDER BY fact_count ASC;
```
