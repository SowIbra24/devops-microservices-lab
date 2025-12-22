#!/bin/bash

echo "....... Test de la calculatrice ................. "

chmod +x ci/test_curl_calculatrice.sh
ci/test_curl_calculatrice.sh
if [ $? -ne 0 ]; then
    echo "Le test de la calculatrice a échoué, arrêt du runner"
    exit 1
fi

echo "....... Fin du test de la calculatrice .......... "

sleep 5 # au cas où la base de données ne serait pas prete

echo "....... Test manuel avec curl de la valeur du compteur ........ "

chmod +x ci/test_curl_app_flask.sh
ci/test_curl_app_flask.sh
if [ $? -ne 0 ]; then
    echo "Le test du compteur a échoué, arrêt du runner"
    exit 1
fi

echo "........ Fin des tests manuels avec curl ...................... "
