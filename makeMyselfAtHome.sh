#!/bin/bash

apt-get install --assume-yes git
mkdir ~/git
mkdir ~/git/agorascript
git clone https://github.com/agoraphobiae/agorascript.git ~/git/agorascript
ln -s ~/git/agorascript/agoraphobiae_rc ~/agoraphobiae_rc
ln -s ~/git/agorascript/.tmux.conf ~/.tmux.conf
echo -e "\n# KL\nsource ~/agoraphobiae_rc" >> ~/.bash_profile
ssh-keygen
cd ~/git/agorascript && git remote set-url origin git@github.com:agoraphobiae/agorascript.git

# get git helpers
mkdir ~/bin
cd ~/bin && curl -O -X GET https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
cd ~/bin && curl -O -X GET https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash

