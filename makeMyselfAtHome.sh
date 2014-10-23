#!/bin/bash

apt-get install --assume-yes git
mkdir ~/git
mkdir ~/git/agorascript
git clone https://github.com/agoraphobiae/agorascript.git ~/git/agorascript
ln -s ~/git/agorascript/agoraphobiae_rc ~/agoraphobiae_rc
echo -e "\n# KL\nsource ~/agoraphobiae_rc" >> ~/.bash_profile
ssh-keygen
cd ~/git/agorascript && git remote set-url origin git@github.com:agoraphobiae/agorascript.git