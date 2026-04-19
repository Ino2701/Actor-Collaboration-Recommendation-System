# 🎬 Actor Collaboration Recommendation System

## 📌 Introduction

This project builds a **graph-based recommendation system** to suggest potential collaborations between actors based on their co-acting history in movies.

Using graph analysis, we model relationships between actors and identify potential collaborations using shared co-stars.

---

## 🎯 Objectives

* Collect large-scale movie and actor data
* Build a graph representing actor collaborations
* Apply graph-based techniques to recommend new actor partnerships
* Analyze collaboration patterns in the film industry

---

## 🗂️ Dataset

Data is collected using the API from The Movie Database.

### Data includes:

* Movies
* Cast (actors)
* Co-acting relationships

### Process:

1. Fetch movie data via API
2. Extract top cast for each movie
3. Create relationships:

   * Actor A ↔ Actor B (if they appear in the same movie)
4. Assign weight = number of collaborations

---

## 🧠 Graph Model

The data is modeled using a graph database with Neo4j.

### Structure:

* **Nodes:** Actor
* **Relationships:** ACTED_WITH
* **Properties:**

  * weight: number of collaborations

```
(Actor)-[:ACTED_WITH {weight}]->(Actor)
```

---

## 🚀 Methodology

### 🔹 Recommendation Logic

Actors are recommended based on **shared co-actors**.

> If two actors have many mutual collaborators, they are more likely to work well together.

---

### 🔹 Cypher Query

```cypher
MATCH (a:Actor {name:"Tom Hanks"})-[:ACTED_WITH]->(c)<-[:ACTED_WITH]-(b)
WHERE NOT EXISTS {
    MATCH (a)-[:ACTED_WITH]->(b)
}
RETURN b.name AS actor, COUNT(c) AS score
ORDER BY score DESC
LIMIT 5
```

---

## 📊 Results

The system outputs:

* Top recommended actors for collaboration
* Score based on number of shared co-actors

Example:

| Actor   | Score |
| ------- | ----- |
| Actor A | 5     |
| Actor B | 4     |

---

## 🔍 Insights

* Actors tend to collaborate within **clusters (communities)**
* Highly connected actors have more collaboration opportunities
* Graph-based recommendation reflects real-world casting patterns

---

## ⚙️ Technologies Used

* Python (data collection & processing)
* The Movie Database API
* Neo4j
* Cypher Query Language

---

## 📁 Project Structure

```
project/
│── data/
│   ├── actors.csv
│   ├── relationships.csv
│
│── scripts/
│   ├── data_collection.py
│
│── neo4j_queries/
│   ├── recommendation.cypher
│
│── README.md
```

---

## 🔥 Future Improvements

* Apply advanced algorithms using Neo4j Graph Data Science

  * Node Similarity
  * PageRank
  * Link Prediction

* Incorporate additional features:

  * Genre similarity
  * Movie ratings
  * Actor popularity

---

## 📌 Conclusion

This project demonstrates how graph databases can be used to:

* Model complex relationships
* Extract meaningful insights
* Build recommendation systems

Graph-based approaches provide a powerful way to analyze collaboration networks in the entertainment industry.

---

## 👨‍💻 Author

* Your Name
* GitHub: https://github.com/yourusername
