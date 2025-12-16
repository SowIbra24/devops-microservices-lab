# devops-microservices-lab
Première version avec un petit programme qui éxécute flask et affiche une page avec un compteur qui s'incrémente
 de 1 à chaque fois qu'on visite la page.
## Exécution sans docker
Pour lancer l'appli, il faut aller dans le dossier `app`
- Installer un dossier qui garde les garde les variables d'environnement 
- Activer la variable d'environnement
- Installer les dépendances
- Et enfin lancer le serveur (on le voit sur localhost:5000/)
```bash
    # Création du dossier
    python3 -m venv venv
    
    #activation de la variable
    source venv/bin/activate

    # installation des dépendances
    pip install -r requirements.txt
    
    # lancer le serveur
    python3 app.py
    
    #pour sortir du venv
    deactivate
```
## Ajout d'un dockerfile pour conteneuriser l'appli.

Conteneuriser l'appli permet une exécution identique sur toute machine ayant un demon docker
Pour cela il faut se rendre dans le dossier `app` : 
- Créer l'image docker
- Lancer l'image en mappant le port du conteneur soit visible depuis l'ordi hote (on le voit sur localhost:5000/).

```bash
    # créer l'image , le "point" à la fin est important pour savoir où trouver le dockerfile 
    # on donner le chemin absolu aussi
    docker build -t image-flask .
    # lancer l'image 
    docker run -p5000:5000 image-flask
```
