docker network create monReseau

docker build -t image-flask .
docker build -t image-bdd bdd/

docker run -d --network=monReseau --name db -e MYSQL_ROOT_PASSWORD=rootpassword \
 -e MYSQL_DATABASE=counterdb -e MYSQL_USER=user -e MYSQL_PASSWORD=password image-bdd

# petit sleep pour que sql demarre

sleep 10

docker run -d --network=monReseau --name app -p5000:5000 image-flask

# petit sleep de syncro
sleep 2
# decommenter cette ligne si vous avez firefox en ligne de commande
 firefox localhost:5000

