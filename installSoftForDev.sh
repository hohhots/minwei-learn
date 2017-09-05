#!/bin/bash

sudo apt-get update
sudo apt-get -y upgrade

COMMANDS=( 'nodejs' 'node' 'npm' 'fab' )
COMMANDS=( 'nodejs' 'nodejs-legacy' 'npm' 'fabric' )

comNum=${#COMMANDS[@]}
for(( i=0;i<$comNum;i++)); do
    echo "Checking if command \"${COMMANDS[${i}]}\" exists! It's package name is ${COMMANDSPACKAGES[${i}]}"
    if [ ! -z `which ${COMMANDS[${i}]}` ]  #if command exist!
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

# config git
configures=( 
            'user.name  brgd'
            'user.email hohhots@qq.com'
            'push.default matching'
            'branch.autosetuprebase always'
            'core.editor "emacs -fs"'
            'color.ui true'
            'color.status auto'
            'color.branch auto'
            'alias.co checkout'
            'alias.ci commit'
            'alias.st status'
            'alias.xfetch "fetch origin"'
            'alias.xdiff "diff origin master"'
            'alias.xmerge "merge origin master"'
            'alias.xpull "pull origin master"'
            'alias.xpush "push origin master"'
            'alias.br branch'
            'alias.type "cat-file -t"'
            'alias.dump "cat-file -p"'
            'alias.hist "log --pretty=format:%h-%ad-|-%s%d-[%an] --graph --date=short"'
            )

comNum=${#configures[@]}
for(( i=0;i<$comNum;i++)); do
    sudo git config --global ${configures[${i}]}
done
echo "git configure completed!"

# os cleaning 
sudo apt-get -y autoremove
sudo apt-get -y autoclean

#fab setup
