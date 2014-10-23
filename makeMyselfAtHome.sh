#!/bin/bash

apt-get install git
mkdir ~/git
mkdir ~/git/agorascript
git clone git@github.com:agoraphobiae/agorascript.git ~/git/agorascript
ln -s ~/git/agorascript/agoraphobiae_rc ~/agoraphobiae_rc
echo -e "\n# KL\nsource ~/agoraphobiae_rc" >> ~/.bash_profile
