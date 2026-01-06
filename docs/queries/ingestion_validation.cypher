
// 1. Counts + orphans
// Basic counts + sanity on relationship completeness.
MATCH (c:CORPUS)
OPTIONAL MATCH (c)-[:CONTAINS]->(d:DOCUMENT)
OPTIONAL MATCH (d)-[:CONTAINS]->(p:PAGE)
OPTIONAL MATCH (p)-[:CONTAINS]->(f:FACT)
RETURN count(DISTINCT c) AS corpora,
       count(DISTINCT d) AS documents,
       count(DISTINCT p) AS pages,
       count(DISTINCT f) AS facts;

// 2. Documents with zero pages
MATCH (d:DOCUMENT)
WHERE NOT (d)-[:CONTAINS]->(:PAGE)
RETURN d { .*, app_id: d.id } AS document
LIMIT 20;

// 3.  Pages with zero facts
MATCH (p:PAGE)
WHERE NOT (p)-[:CONTAINS]->(:FACT)
RETURN p { .*, app_id: p.id } AS page
LIMIT 50;

// 4. Facts with zero questions
MATCH (f:FACT)
WHERE NOT (f)-[:QUESTION]->(:PAGE)
RETURN f { .*, app_id: f.id } AS fact
LIMIT 50;

// 5. Page text missing/empty
MATCH (p:PAGE)
WHERE p.text IS NULL OR trim(p.text) = ""
RETURN p { .*, app_id: p.id } AS page
LIMIT 50;

// 6. Fact distribution per page (basic)
MATCH (p:PAGE)
OPTIONAL MATCH (p)-[:CONTAINS]->(f:FACT)
WITH p, count(f) AS fact_count
RETURN fact_count, count(*) AS pages
ORDER BY fact_count ASC;

