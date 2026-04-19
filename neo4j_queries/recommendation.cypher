////////////////////////////////////////
// 🎬 ACTOR GRAPH ANALYSIS & RECOMMENDATION
////////////////////////////////////////

//////////////////////////////////////////////////
// 1. Kiểm tra dữ liệu (sanity check)
//////////////////////////////////////////////////

// Tổng số Actor
MATCH (a:Actor)
RETURN COUNT(a) AS total_actors;

// Tổng số quan hệ
MATCH ()-[r:ACTED_WITH]->()
RETURN COUNT(r) AS total_relationships;

//////////////////////////////////////////////////
// 2. Top Actor có nhiều kết nối nhất (Degree)
//////////////////////////////////////////////////

MATCH (a:Actor)-[:ACTED_WITH]->(b)
RETURN a.name AS actor, COUNT(b) AS degree
ORDER BY degree DESC
LIMIT 10;

//////////////////////////////////////////////////
// 3. Actor nổi bật (weighted degree)
//////////////////////////////////////////////////

MATCH (a:Actor)-[r:ACTED_WITH]->(b)
RETURN a.name AS actor, SUM(r.weight) AS total_collaborations
ORDER BY total_collaborations DESC
LIMIT 10;

//////////////////////////////////////////////////
// 4. Kiểm tra network của 1 actor (Visualization)
//////////////////////////////////////////////////

MATCH (a:Actor {name:"Tom Hanks"})-[r:ACTED_WITH]->(b)
RETURN a, r, b
LIMIT 30;

//////////////////////////////////////////////////
// 5. Recommendation (Core - basic)
//////////////////////////////////////////////////

MATCH (a:Actor {name:"Tom Hanks"})-[:ACTED_WITH]->(c)<-[:ACTED_WITH]-(b)
WHERE NOT EXISTS {
MATCH (a)-[:ACTED_WITH]->(b)
}
RETURN b.name AS recommended_actor, COUNT(c) AS score
ORDER BY score DESC
LIMIT 5;

//////////////////////////////////////////////////
// 6. Recommendation nâng cao (có weight)
//////////////////////////////////////////////////

MATCH (a:Actor {name:"Tom Hanks"})-[r1:ACTED_WITH]->(c)<-[r2:ACTED_WITH]-(b)
WHERE NOT EXISTS {
MATCH (a)-[:ACTED_WITH]->(b)
}
RETURN b.name AS recommended_actor,
SUM(r1.weight + r2.weight) AS score
ORDER BY score DESC
LIMIT 5;

//////////////////////////////////////////////////
// 7. Top cặp actor hợp tác nhiều nhất
//////////////////////////////////////////////////

MATCH (a:Actor)-[r:ACTED_WITH]->(b)
RETURN a.name AS actor1, b.name AS actor2, r.weight AS collaborations
ORDER BY collaborations DESC
LIMIT 10;

//////////////////////////////////////////////////
// 8. Tìm “cầu nối” giữa 2 actor (Shortest Path)
//////////////////////////////////////////////////

MATCH p = shortestPath(
(a:Actor {name:"Tom Hanks"})-[:ACTED_WITH*..5]-(b:Actor {name:"Leonardo DiCaprio"})
)
RETURN p;

//////////////////////////////////////////////////
// 9. Gợi ý theo khoảng cách (2-hop recommendation)
//////////////////////////////////////////////////

MATCH (a:Actor {name:"Tom Hanks"})-[:ACTED_WITH*2]-(b)
WHERE NOT (a)-[:ACTED_WITH]->(b) AND a <> b
RETURN b.name AS actor, COUNT(*) AS score
ORDER BY score DESC
LIMIT 5;

//////////////////////////////////////////////////
// 10. Phân tích clustering (cộng đồng nhỏ)
//////////////////////////////////////////////////

MATCH (a:Actor)-[:ACTED_WITH]->(b)
WITH a, COUNT(b) AS connections
WHERE connections > 20
RETURN a.name, connections
ORDER BY connections DESC
LIMIT 10;

//////////////////////////////////////////////////
// END
//////////////////////////////////////////////////
