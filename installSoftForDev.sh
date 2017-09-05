#!/bin/bash

sudo apt-get update
sudo apt-get -y upgrade

COMMANDS=( 'nodejs' 'node' 'npm' )
COMMANDS=( 'nodejs' 'nodejs-legacy' 'npm' )

comNum=${#COMMANDS[@]}
for(( i=0;i<$comNum;i++)); do
    echo "Checking if command \"${COMMANDS[${i}]}\" exists! It's package name is ${COMMANDSPACKAGES[${i}]}"
    #if command exist!
    if [ ! -z `which ${COMMANDS[${i}]}` ] 
    then
        echo "${COMMANDS[${i}]} already installed, and will be REMOVED!!!!"
        sudo apt-get remove -y --purge ${COMMANDSPACKAGES[${i}]}
    fi
    
    sudo apt-get install -y ${COMMANDSPACKAGES[${i}]}
    echo "${COMMANDS[${i}]} installed!"
    
done

# npm install process
sudo npm install --global gulp-cli

# install npm plugin packages
npmPackages=( 
                'apache-server-configs'
                'babel-core'
                'babel-preset-es2015'
                'browser-sync'
                'del'
                'eslint-config-google'
                'gulp'
                'gulp-autoprefixer'
                'gulp-babel'
                'gulp-cache'
                'gulp-concat'
                'gulp-cssnano'
                'gulp-eslint'
                'gulp-htmlmin'
                'gulp-if'
                'gulp-imagemin'
                'gulp-load-plugins'
                'gulp-newer'
                'gulp-sass'
                'gulp-size'
                'gulp-sourcemaps'
                'gulp-uglify'
                'gulp-useref'
                'psi'
                'run-sequence'
                'sw-precache'
                'sw-toolbox'
            )

DIR=node_modules
if [ -d "$DIR" ]; then
    printf '%s\n' "Removing node module directory ($DIR)"
    rm -rf "$DIR"
fi

comNum=${#npmPackages[@]}
for(( i=0;i<$comNum;i++)); do
    sudo npm install --save-dev ${npmPackages[${i}]}
    echo "${npmPackages[${i}]} installed!"
    
done

# os cleaning 
sudo apt-get -y autoremove
sudo apt-get -y autoclean

fab setup
