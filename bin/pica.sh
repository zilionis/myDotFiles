#!/bin/bash
NAME='Express:'
SOURCE=`curl -silent http://www.noriupicos.lt/picos/ | egrep '<h2>' | shuf -n 1 | sed -e 's/<[^<]*>//g' 2>&1`
if [[ $# > 0 ]]; then
    if [[ $1 == 'dom' ]]; then
        NAME='Dominium:'
        SOURCE=`curl -silent http://www.pizzadominium.lt/lt/ozas/cennik/picos/ | grep "209" | grep -v "nbsp" | sed 's/<[^<]*>//g' | shuf -n 1 2>&1`
    fi

    if [[ $1 == 'pizzapub' ]]; then
        NAME='Pizza Pub:'
        SOURCE=`curl pizzapub.lt  -s | grep 'class="name"' -A 1 | egrep -v "div|\--|krep" | shuf -n 1 | sed -e 's/\W//g'`
    fi
fi
cowsay $NAME $SOURCE