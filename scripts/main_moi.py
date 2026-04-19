import requests
import time
from collections import defaultdict
import itertools
import csv

API_KEY = "051ce71d8d18f000a04d8c04e452019f"

# =========================
# 1. Lấy danh sách phim
# =========================
def get_movies(page):
    url = "https://api.themoviedb.org/3/discover/movie"
    params = {
        "api_key": API_KEY,
        "page": page,
        "sort_by": "popularity.desc"
    }
    return requests.get(url, params=params).json()

# =========================
# 2. Lấy cast của phim
# =========================
def get_cast(movie_id):
    url = f"https://api.themoviedb.org/3/movie/{movie_id}/credits"
    params = {"api_key": API_KEY}
    return requests.get(url, params=params).json()

# =========================
# 3. Crawl data
# =========================
movie_cast = {}

for page in range(1, 30):  # tăng lên nếu muốn nhiều data hơn
    print(f"Page {page}")
    
    data = get_movies(page)
    
    for movie in data['results']:
        movie_id = movie['id']
        title = movie['title']
        
        cast_data = get_cast(movie_id)
        
        cast_list = [
            actor['name']
            for actor in cast_data.get('cast', [])[:8]  # lấy top 8 actor
        ]
        
        if len(cast_list) > 1:
            movie_cast[title] = cast_list
        
        time.sleep(0.2)  # tránh bị block API

# =========================
# 4. Build graph
# =========================
edges = defaultdict(int)

for cast in movie_cast.values():
    for a, b in itertools.combinations(cast, 2):
        pair = tuple(sorted([a, b]))
        edges[pair] += 1

# =========================
# 5. Xuất actors.csv
# =========================
actors = set()

for a, b in edges:
    actors.add(a)
    actors.add(b)

with open("actors.csv", "w", newline="", encoding="utf-8") as f:
    writer = csv.writer(f)
    writer.writerow(["name"])
    
    for actor in actors:
        writer.writerow([actor])

# =========================
# 6. Xuất relationships.csv
# =========================
with open("relationships.csv", "w", newline="", encoding="utf-8") as f:
    writer = csv.writer(f)
    writer.writerow(["actor1", "actor2", "weight"])
    
    for (a, b), w in edges.items():
        writer.writerow([a, b, w])

print("DONE!")