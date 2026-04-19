// Recommendation query
MATCH (a:Actor {name:"Tom Hanks"})-[:ACTED_WITH]->(c)<-[:ACTED_WITH]-(b)
WHERE NOT EXISTS {
    MATCH (a)-[:ACTED_WITH]->(b)
}
RETURN b.name AS actor, COUNT(c) AS score
ORDER BY score DESC
LIMIT 5;


// Top connected actors
MATCH (a:Actor)-[:ACTED_WITH]->(b)
RETURN a.name, COUNT(b) AS degree
ORDER BY degree DESC
LIMIT 10;


// Sample graph
MATCH (a:Actor)-[r:ACTED_WITH]->(b)
RETURN a, r, b LIMIT 50;