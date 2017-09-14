#!/bin/bash

# add nodejs 8 repository
    sudo apt install -y curl
    curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
    
# install software
    COMMANDS=( 'nodejs' 'node' 'npm' 'fab' )
    COMMANDSPACKAGES=( 'nodejs' 'nodejs-legacy' 'npm' 'fabric' )

    comNum=${#COMMANDS[@]}
    for(( i=0;i<$comNum;i++)); do
        echo "Checking if command \"${COMMANDS[${i}]}\" exists! It's package name is ${COMMANDSPACKAGES[${i}]}"
        #if command exist!
        if [ ! -z `which ${COMMANDS[${i}]}` ]
        then
            echo "${COMMANDS[${i}]} already installed, and will be REMOVED!!!!"
            sudo apt remove -y --purge ${COMMANDSPACKAGES[${i}]}
        fi

        sudo apt install -y ${COMMANDSPACKAGES[${i}]}
        echo "${COMMANDS[${i}]} installed!"

    done

# set user profile to install npm packages globally without sudo on macOS and Linux
    npmpackages="${HOME}/.npm-packages"
    mkdir $npmpackages

    npmrc=${HOME}/.npmrc
    rm "$npmrc"
    echo "prefix=${HOME}/.npm-packages" >> "$npmrc"

    bashrc=${HOME}/.bashrc
    echo 'NPM_PACKAGES="${HOME}/.npm-packages"' >> "$bashrc"
    echo 'PATH="$NPM_PACKAGES/bin:$PATH"' >> "$bashrc"

    # Unset manpath so we can inherit from /etc/manpath via the `manpath` command
    echo "unset MANPATH" >> "$bashrc"
    # delete if you already modified MANPATH elsewhere in your config
    echo 'export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"' >> "$bashrc"
    

#set environment
    source ~/.bashrc

# npm install process
    #npm install --global gulp-cli

# install npm packages 
    #globally for develop
    npmPackages=(
                'gulp'
                'bower'
                'node-inspector'
    )

    comNum=${#npmPackages[@]}
    for(( i=0;i<$comNum;i++)); do
        npm install ${npmPackages[${i}]} -g
        echo "${npmPackages[${i}]} installed!"

    done

    # local for develop
    npm install

# os cleaning 
    sudo apt-get -y autoremove
    sudo apt-get -y autoclean

# call fabric
    fab setup
