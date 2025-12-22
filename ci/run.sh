#!/bin/bash

sleep 15

echo "....... Test de la calculatrice ................. "

chmod +x ./test_curl_calculatrice.sh
./test_curl_calculatrice.sh
if [ $? -ne 0 ]; then
    echo "Le test de la calculatrice a échoué, arrêt du runner"
    exit 1
fi

echo "....... Fin du test de la calculatrice .......... "


echo "....... Test manuel avec curl de la valeur du compteur ........ "

chmod +x ./test_curl_app_flask.sh
./test_curl_app_flask.sh
if [ $? -ne 0 ]; then
    echo "Le test du compteur a échoué, arrêt du runner"
    exit 1
fi

echo "........ Fin des tests manuels avec curl ...................... "
