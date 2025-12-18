docker network create monReseau

docker build -t image-flask .
docker build -t image-bdd bdd/

docker run -d --network=monReseau --name db -v mysql_data:/var/lib/mysql image-bdd

# petit sleep pour que sql démarre

sleep 10

docker run -d --network=monReseau --name app -p5000:5000 image-flask

# petit sleep de synchro
sleep 2
# décommenter cette ligne si vous avez firefox en ligne de commande
 firefox localhost:5000 &

