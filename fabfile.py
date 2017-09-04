#Run initPackages.sh first to install required packages in ubuntu.

from __future__ import with_statement
from fabric.api import env, local, run, lcd, cd, sudo
import os
from fabric.contrib.files import exists

gitAlias = [
            'user.name  brgd',
            'user.email hohhots@qq.com',
            'push.default matching',
            'branch.autosetuprebase always',
            'core.editor \'emacs -fs\'',
            'color.ui true',
            'color.status auto',
            'color.branch auto',
            'alias.co checkout',
            'alias.ci commit',
            'alias.st status',
            'alias.xfetch \'fetch origin\'',
            'alias.xdiff \'diff origin master\'',
            'alias.xmerge \'merge origin master\'',
            'alias.xpull \'pull origin master\'',
            'alias.xpush \'push origin master\'',
            'alias.br branch',
            'alias.type \'cat-file -t\'',
            'alias.dump \'cat-file -p\'',
            'alias.hist \'log --pretty=format:%h-%ad-|-%s%d-[%an] --graph --date=short\''
           ]

def localGitConfig():
    for alias in gitAlias:
        local('git config --global ' + alias)

def setup(): 
	localGitConfig()
