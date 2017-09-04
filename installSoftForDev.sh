#!/bin/bash

sudo apt-get update && sudo apt-get -y upgrade

COMMANDS=( 'nodejs') # 'node' 'git' )

COMMANDSPACKAGES=( 'nodejs' 'nodejs-legacy' 'git' )

comNum=${#COMMANDS[@]}
for(( i=0;i<$comNum;i++)); do
    echo "Checking if command \"${COMMANDS[${i}]}\" exists! It's package name is ${COMMANDSPACKAGES[${i}]}"
    if [ ! -z `which ${COMMANDS[${i}]}` ]  #if command exist!
    then
        echo "${COMMANDS[${i}]} already installed!"
        sudo apt-get remove -y --purge ${COMMANDSPACKAGES[${i}]}
    fi
        sudo apt-get install -y ${COMMANDSPACKAGES[${i}]}
        echo "${COMMANDS[${i}]} installed!"
    
done

sudo apt-get -y autoremove

#fab setup
