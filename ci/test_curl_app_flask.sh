#!/bin/bash

url="http://localhost:5000"
incr=5

val_init=$(curl -s $url | grep -oP '(?<=Compteur : )\d+')
echo "Valeur initiale du compteur : $val_init"

echo "j'incrémente 5 fois le compteur ......"
for i in $(seq 1 $incr); do
  if [ "$i" -eq "$incr" ]; then
      val_final=$(curl -s $url | grep -oP '(?<=Compteur : )\d+')
  else
    curl -s $url > /dev/null
    sleep 0.2
  fi
done

echo -e " Fin de l'incrémentation"

echo "Compteur actuel: $val_final"

expected=$((val_init + incr))

echo "expected = $expected"
if [ "$val_final" -eq "$expected" ]; then
    echo "Test compteur OK"
    exit 0
else
    echo "Test compteur FAIL"
    exit 1
fi
