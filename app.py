from flask import Flask

app = Flask(__name__)
count = 0

@app.route("/")
def index():
    global count
    count += 1
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

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
