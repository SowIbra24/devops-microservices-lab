<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mini Formulaire PHP</title>
</head>
<body>
    <h1>Mini Formulaire PHP </h1>
    <form method="post">
        <label>Nombre 1: <input type="number" name="n1" required></label><br><br>
        <label>Nombre 2: <input type="number" name="n2" required></label><br><br>
        <button type="submit">Additionner</button>
    </form>

    <?php
    if ($_SERVER["REQUEST_METHOD"] === "POST") {
        $n1 = (float)$_POST["n1"];
        $n2 = (float)$_POST["n2"];
        $somme = $n1 + $n2;
        echo "<h2>Résultat : $n1 + $n2 = $somme</h2>";
    }
    ?>
</body>
</html>
