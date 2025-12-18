docker stop db app phpmyadmin
docker rm db app phpmyadmin
docker rmi image-bdd image-flask image-phpmyadmin
docker network rm monReseau