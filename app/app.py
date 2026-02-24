from flask import Flask
import mysql.connector
import time
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST

app = Flask(__name__)

VISITS = Counter('flask_app_hits_total', 'Nombre total de visites sur le serveur Flask')

def get_db_connection():
    return mysql.connector.connect(
        host="db",
        user="user",
        password="password",
        database="counterdb"
    )

@app.route("/")
def index():
    VISITS.inc()
    db = get_db_connection()
    cursor = db.cursor()
    cursor.execute("CREATE TABLE IF NOT EXISTS counter_table (id INT PRIMARY KEY, count INT)")
    cursor.execute("INSERT IGNORE INTO counter_table (id, count) VALUES (1, 0)")
    cursor.execute("UPDATE counter_table SET count = count + 1 WHERE id=1")
    db.commit()
    cursor.execute("SELECT count FROM counter_table WHERE id=1")
    count = cursor.fetchone()[0]
    db.close()
    html = f"""<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Compteur</title>
</head>
<body>
    <h1>Compteur : {count}</h1>
</body>
</html>
"""
    return html

@app.route("/metrics")
def metrics():
    return generate_latest(), 200, {'Content-Type': CONTENT_TYPE_LATEST}

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
