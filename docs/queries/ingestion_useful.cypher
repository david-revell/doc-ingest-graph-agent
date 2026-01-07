
// 1. List corpora and their names
MATCH (c:CORPUS)
RETURN c.name AS corpus_name
ORDER BY corpus_name;

// 2. Documents under a given corpus (set corpus_name)
WITH "Citigroup" AS corpus_name
MATCH (c:CORPUS {name: corpus_name})-[:CONTAINS]->(d:DOCUMENT)
RETURN d.name AS document_name
ORDER BY document_name;

// 3. Number of documents per corpus
MATCH (c:CORPUS)
OPTIONAL MATCH (c)-[:CONTAINS]->(d:DOCUMENT)
RETURN c.name AS corpus_name, count(DISTINCT d) AS documents
ORDER BY corpus_name;

// 4. Number of pages by document under a given corpus
WITH "Citigroup" AS corpus_name
MATCH (c:CORPUS {name: corpus_name})-[:CONTAINS]->(d:DOCUMENT)
OPTIONAL MATCH (d)-[:CONTAINS]->(p:PAGE)
RETURN d.name AS document_name, count(DISTINCT p) AS pages
ORDER BY pages DESC, document_name;

// 5. Number of facts by document under a given corpus
WITH "Citigroup" AS corpus_name
MATCH (c:CORPUS {name: corpus_name})-[:CONTAINS]->(d:DOCUMENT)
OPTIONAL MATCH (d)-[:CONTAINS]->(:PAGE)-[:CONTAINS]->(f:FACT)
RETURN d.name AS document_name, count(DISTINCT f) AS facts
ORDER BY facts DESC, document_name;

// 6. Pages with zero facts under a given corpus
WITH "Citigroup" AS corpus_name
MATCH (c:CORPUS {name: corpus_name})-[:CONTAINS]->(d:DOCUMENT)-[:CONTAINS]->(p:PAGE)
WHERE NOT (p)-[:CONTAINS]->(:FACT)
RETURN d.name AS document_name, p.name AS page_name
ORDER BY document_name, page_name
LIMIT 50;

// 7. Top facts by document under a given corpus (sample 3 per doc)
WITH "Citigroup" AS corpus_name
MATCH (c:CORPUS {name: corpus_name})-[:CONTAINS]->(d:DOCUMENT)-[:CONTAINS]->(:PAGE)-[:CONTAINS]->(f:FACT)
WITH d, collect(DISTINCT f.name)[0..3] AS sample_facts
RETURN d.name AS document_name, sample_facts
ORDER BY document_name;

// 8. Pages missing text under a given corpus
WITH "Citigroup" AS corpus_name
MATCH (c:CORPUS {name: corpus_name})-[:CONTAINS]->(d:DOCUMENT)-[:CONTAINS]->(p:PAGE)
WHERE p.text IS NULL OR trim(p.text) = ""
RETURN d.name AS document_name, p.name AS page_name
ORDER BY document_name, page_name
LIMIT 50;

// 9. Facts with no questions under a given corpus
WITH "Citigroup" AS corpus_name
MATCH (c:CORPUS {name: corpus_name})-[:CONTAINS]->(d:DOCUMENT)-[:CONTAINS]->(:PAGE)-[:CONTAINS]->(f:FACT)
WHERE NOT (f)-[:QUESTION]->(:PAGE)
RETURN d.name AS document_name, f.name AS fact
ORDER BY document_name
LIMIT 50;

// 10. Total counts (corpora, documents, pages, facts, questions)
MATCH (c:CORPUS)
OPTIONAL MATCH (c)-[:CONTAINS]->(d:DOCUMENT)
OPTIONAL MATCH (d)-[:CONTAINS]->(p:PAGE)
OPTIONAL MATCH (p)-[:CONTAINS]->(f:FACT)
OPTIONAL MATCH (f)-[:QUESTION]->(q:PAGE)
RETURN count(DISTINCT c) AS corpora,
       count(DISTINCT d) AS documents,
       count(DISTINCT p) AS pages,
       count(DISTINCT f) AS facts,
       count(DISTINCT q) AS questions;
