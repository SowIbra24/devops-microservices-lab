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
Pour ne plus avoir à trainer un gros dossier venv sur chaque ordinateur où l'application s'éxécute, j'ai décidé de conteneuriser 
l'application. Cela permet notamment une exécution identique sur toute machine ayant un demon docker
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
# Feat : L'appli utilise maintenant une bdd pour stocker la variable count
Avant, l'application gardait dans sa mémoire la variable count. Lorsque le serveur redémarrait, la variable revenait à 0.  
Pour palier à ce problème, j'ai mis la variable dans une base de données.  
Cela est compliqué à exécuter en local parce qu'il faudrait installer un serveur complet pour gérer la base de donnée.  
Donc pour ce faire, je choisi de créer une image docker de mysql.

## Exécution des 2 conteneurs ensemble (si vous voulez le faire en une fois allez au paragraphe suivant)
L'application va se connecter à la base de donnés, donc il faut que les 2 services puissent communiquer, pour cela, il faut :
- Creer un réseau pour que les 2 services puissent communiquer et les mettre dedans.
- Construire les 2 images (comme on avait fait précédemment)
- Lancer les 2 conteneurs (la base de données en premier, il faut qu'elle soit opérationnelle avant que l'app ne se connecte).
Pour le faire, placer vous à la racine du projet `app` et faites : 

```bash
    
    # création du réseau docker
    docker network create monReseau
    
    # Construire les 2 images 
    docker build -t image-flask .
    docker build -t image-bdd bdd/
    
    # lancer les conteneurs 
    
    # la base de connées puis attendez environ 10s qu'il démarre 
    docker run -d --network=monReseau --name db -e MYSQL_ROOT_PASSWORD=rootpassword \
    -e MYSQL_DATABASE=counterdb -e MYSQL_USER=user -e MYSQL_PASSWORD=password image-bdd
    
    # l'application
    docker run -d --network=monReseau --name app -p5000:5000 image-flask
```
Connectez vous à `localhost:5050` sur votre navigateur préféré et admirer la magie x) 

### Script d'automatisation 
Si vous etes un flemmard comme moi, je vous ai fait un petit script qui automatise tout ça.  
Exécutez le script `create-and-setup.sh` ou `delete.sh` à la racine du projet:
```shell
  # droits d'éxécution
  chmod +x create-and-setup.sh delete.sh
  
  # lancement
  ./create-and-setup.sh
  
  # pour supprimer réseau conteneurs et images
  ./delete.sh
```
Si vous avez décommentez la dernière ligne du script, tout s'automatise jusqu'à l'ouverture de la page.  
Sinon, connectez vous à `localhost:5050` sur votre navigateur préféré et admirer la magie x) 

**Maintenant, vous pouvez arreter le conteneur du serveur flask et le rallumer, la valeur du compteur augmentera 
tant que le serveur bdd tournera**

**Que se passera t'il si le conteneur du serveur bdd tombait en panne?**
- Le compteur reviendrais 0 si on rallume le conteneur de la base de donnée.
Pour eviter cela, on va monter un volume dans le conteneur de la bdd et la bdd écrira et lira sur ce volume

## Montage du volume pour la base de données 
Pour cette première partie, il faut : 
- Créer un volume
- Lancer le conteneur de la base de données avec une option en plus qui permet de spécifier le volume

```bash
    # créer le volume
    docker volume create mysql_data

    # la base de connées puis attendez environ 10s qu'il démarre    
    docker run -d --network=monReseau --name db -e MYSQL_ROOT_PASSWORD=rootpassword \   
    -e MYSQL_DATABASE=counterdb -e MYSQL_USER=user -e MYSQL_PASSWORD=password -v mysql_data:/var/lib/mysql image-bdd               
```
Maintenant meme après suppression ou redemarrage des conteneurs, la bse de données est stockée en local, donc le compteur 
ne reviendra plus à zero à part si on le fait depuis la base de données ou si on la supprime elle aussi.

**C'est bien joli une base de donées qui tourne, mais actuellement elle n'est accéssible qu'avec un programme (app par exemple)
ou en ligne de commandes.  
Et si on lui donnait une interface graphique à partir de la quelle on puisse la modifier ?**

# Feat : Interface graphique PhpMyAdmin pour administrer la base de données en GUI 
Bien qu'on aurait pu directement lancer le conteneur phpmyadmin et lui donner les variables d'environnement, je vais faire un dockerfile
comme les autres.  
Et je l'ajoute dans le workflow dans les scripts de lancement et de suppression.

Pour voir l'exécution, lancez le script `create-and-setup.sh` puis connectez  à `localhost:8081`, vous pouvez maintenant administrer 
votre base de données avec l'interface graphique (modifier la valeur du compteur par exemple) .

# Feat : Automatisation du lancement et de la gestion des conteneurs (docker-compose)
Jusqu'à maintenant, j'avais fait des petits scripts d'automatisation en bas pour lancer et arreter les conteneurs.  
Je vais maintenant utiliser l'outil `docker-compose` pour gerer la dépendance des conteneurs (qui se lance avant qui) et bien 
parametrer les conteneurs avec par exemple l'attribut `restart : always` qui relance un conteneur dès qu'il s'arrete.

Pour lancer les services maintenant, il faut etre à la racine de ce projet et faire : 

```bash
    # lancer les conteneurs (-d pour le faire en arrière plan) 
    docker-compose up -d 
    
    # arreter les conteneurs (ajouter l'option -v pour supprimer le volume aussi)
    docker-compose down 
```
Le `depends_on:` garantit que la base de données sera créée avant tous les autres conteneurs mais ne garantit pas qu'elle 
sera operationnelle avant la création des autres.  
Il faudra donc attendre un peu (l'équivalent des sleep dans le script), mais tout marchera.