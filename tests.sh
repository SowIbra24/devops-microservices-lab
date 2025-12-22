#!/bin/bash
set -e

echo "Je lance les conteneurs"
docker-compose up --build -d
echo "je lance les tests"
docker logs -f tests &
docker wait tests
EXIT_CODE=$(docker inspect tests --format='{{.State.ExitCode}}')
echo "Les tests sont finis"
docker rm -f tests 2>/dev/null
echo "j'éteins tout"
docker-compose down -v
exit $EXIT_CODE
