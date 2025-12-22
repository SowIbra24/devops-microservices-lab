#!/bin/bash

url="http://calculatrice/"

n1=7
n2=5
expected=$((n1 + n2))

echo "Test de la calculatrice : $n1 + $n2 = $expected"

result=$(curl -s -X POST "$url" \
    -d "n1=$n1" -d "n2=$n2" | sed -n 's/.*= \([0-9]\+\).*/\1/p')

echo "Résultat renvoyé par le serveur : $result"

if [ "$result" -eq "$expected" ]; then
    echo "Test calculatrice OK"
    exit 0
else
    echo "Test calculatrice FAIL"
    exit 1
fi
