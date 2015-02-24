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
if [ -L ~/.tmux.conf ]; then
    mv ~/.tmux.conf ~/.tmux.conf.prephorust
fi
ln -s ~/git/dotfiles/tmux.conf ~/.tmux.conf
echo -e "\n# KL\nsource ~/git/dotfiles/bash_profile" >> ~/.bash_profile
if [ -L ~/.vimrc ]; then
    mv ~/.vimrc ~/.vimrc.prephorust
fi
ln -s ~/git/dotfiles/vimrc ~/.vimrc

function setup_ssh {
	ssh-keygen
	echo "======= COPY BELOW THIS LINE FOR SETTING UP THIS KEY (on github) ======="
	cat ~/.ssh/id_rsa.pub
	echo "======= COPY ABOVE THIS LINE FOR SETTING UP THIS KEY (on github) ======="
}
echo "Generate an ssh-key?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) setup_ssh; break;;
        No ) echo "Ok. You may need to update the git remote in ~/git/dotfiles if later you want to commit."; break;;
    esac
done
if [ -f ~/.ssh/id_rsa.pub ]; then
    cd ~/git/dotfiles && git remote set-url origin git@github.com:phorust/dotfiles.git
fi

# get git helpers
mkdir ~/bin
cd ~/bin && curl -O -X GET https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
cd ~/bin && curl -O -X GET https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash

# set up extra vim stuff
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

# set up extra tmux stuff
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm


if [[ "$(uname)" == Darwin* ]]; then
    # get brew
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew doctor
    # for compiling YCM
    brew install cmake
    # for better git
    brew install git
    # htop > top
    brew install htop-osx
    # for YCM python
    brew install python
    # brew link --overwrite python # don't link or YCM compile wont work
    brew install python3
    brew link --overwrite python3
    # for j
    brew install autojump
    # for mosh
    brew install mobile-shell
    # for tmux
    brew install tmux
    # for tmux-yank and other fancy fancies
    brew install reattach-to-user-namespace

    # make keys repeat properly
    defaults write -g ApplePressAndHoldEnabled -bool false
    defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
    defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
fi


# echo post-install stuff
echo "************** INSTALL COMPLETE **************"
echo "you're also going to want:"
echo "Alfred"
echo "MacVim / alias mvim"
echo "Seil / capslock remap"
echo "iTerm2 / zsh"
echo "ShiftIt (beta)"
echo "Dropbox"
echo "Sublime 3"
echo "Spotify / Chrome / Vox"
echo "compile YCM"
echo "NOTE: FOR KEYBOARD CHANGES TO WORK CORRECTLY, LOG OUT AND BACK IN"
