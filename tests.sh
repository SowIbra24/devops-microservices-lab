#!/bin/bash
set -e

echo " --------------------- Je lance les conteneurs -------------------------"
docker-compose up --build -d
sleep 10
echo " -------------------- je lance les tests -------------------------------"
docker logs -f ${COMPOSE_PROJECT_NAME}_tests &
docker wait ${COMPOSE_PROJECT_NAME}_tests
EXIT_CODE=$(docker inspect ${COMPOSE_PROJECT_NAME}_tests --format='{{.State.ExitCode}}')
echo " -------------------- Les tests sont finis -----------------------------"
echo " -------------------- j'éteins tout ------------------------------------"
docker-compose down
exit $EXIT_CODE
