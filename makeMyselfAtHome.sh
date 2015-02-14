#!/bin/bash
# requires git to exist
# symlinks vimrc, bash_profile, tmux_conf

if hash apt-get 2>/dev/null; then
	apt-get install --assume-yes git
fi
mkdir ~/git
if [ -d ~/git/dotfiles ]; then
	# dotfiles already set up?
	echo "~/git/dotfiles already exists! Delete and start fresh?"

	select yn in "Yes" "No"; do
	    case $yn in
		Yes ) rm -rf ~/git/dotfiles; break;;
		No ) echo "Ok. exiting..."; exit;;
	    esac
	done
fi
mkdir ~/git/dotfiles
git clone https://github.com/phorust/dotfiles.git ~/git/dotfiles
if [ -L ~/.tmux.conf]; then
    mv ~/.tmux.conf ~/.tmux.conf.prephorust
ln -s ~/git/dotfiles/tmux.conf ~/.tmux.conf
echo -e "\n# KL\nsource ~/git/dotfiles/bash_profile" >> ~/.bash_profile
ln -s ~/git/dotfiles/vimrc ~/.vimrc
if [ -L ~/.vimrc ]; then
    mv ~/.vimrc ~/.vimrc.prephorust

function setup_ssh {
	ssh-keygen
	echo "======= COPY BELOW THIS LINE FOR SETTING UP THIS KEY (on github) ======="
	cat ~/.ssh/id_rsa.pub
	echo "======= COPY ABOVE THIS LINE FOR SETTING UP THIS KEY (on github) ======="
	cd ~/git/dotfiles && git remote set-url origin git@github.com:phorust/dotfiles.git
}
echo "Generate an ssh-key?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) setup_ssh; break;;
        No ) echo "Ok. You may need to update the git remote in ~/git/dotfiles if later you want to commit."; break;;
    esac
done

# get git helpers
mkdir ~/bin
cd ~/bin && curl -O -X GET https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
cd ~/bin && curl -O -X GET https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash

