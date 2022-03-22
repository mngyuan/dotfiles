#!/bin/bash
# requires git to exist
# symlinks vimrc, zshrc, tmux_conf

part_one () {
	if hash apt-get 2>/dev/null; then
		# neovim (more recent versions)
		sudo add-apt-repository ppa:neovim-ppa/stable
		sudo apt-get update

		sudo apt-get install --assume-yes git curl vim tmux autojump htop cmake cgdb xclip zsh
		sudo apt-get install --assume-yes neovim python-dev python-pip python3-dev python3-pip
		sudo apt-get install --assume-yes nodejs
		sudo apt-get install -y python-software-properties software-properties-common
	fi
	mkdir ~/git
	if [ -d ~/git/dotfiles ]; then
		# dotfiles already set up?
		echo "~/git/dotfiles already exists! If oh-my-zsh is now installed, skip to part 2."

		select sq in "Skip" "Quit"; do
			case $sq in
				Skip ) part_two; break;;
				Quit ) echo "Ok. exiting..."; exit;;
			esac
		done
		fi
		mkdir ~/git/dotfiles
		git clone https://github.com/mngyuan/dotfiles.git ~/git/dotfiles

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
		cd ~/git/dotfiles && git remote set-url origin git@github.com:mngyuan/dotfiles.git
	fi

	# set up oh-my-zsh and extra zsh stuff
	# this will open a new shell, zsh, so the remainder of the commands must be run seperately
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}


part_two() {
	git clone git://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	git clone git://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
	# set up extra vim stuff
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	vim +PlugInstall +qall
	curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	nvim +PlugInstall +UpdateRemotePlugins +qall
	nvim +"CocInstall coc-json coc-tsserver coc-html coc-css coc-eslint coc-prettier coc-yaml"
	# set up extra tmux stuff
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

	# now, lets hook up our actual dotfiles
	if [ -L ~/.tmux.conf ]; then
		mv ~/.tmux.conf ~/.tmux.conf.premngyuan
	fi
	ln -s ~/git/dotfiles/tmux.conf ~/.tmux.conf
	if [ -L ~/.vimrc ]; then
		mv ~/.vimrc ~/.vimrc.premngyuan
	fi
	ln -s ~/git/dotfiles/vimrc ~/.vimrc
	mkdir -p ~/.config/nvim
	ln -s ~/git/dotfiles/init.vim ~/.config/nvim/init.vim
	if [ -L ~/.zshrc ]; then
		mv ~/.zshrc ~/.zshrc.premngyuan
	fi
	ln -s ~/git/dotfiles/zshrc ~/.zshrc
	if [ -L ~/.zshenv ]; then
		mv ~/.zshenv ~/.zshenv.premngyuan
	fi
	ln -s ~/git/dotfiles/zshenv ~/.zshenv
	if [ -L ~/.zprofile ]; then
		mv ~/.zprofile ~/.zprofile.premngyuan
	fi
	ln -s ~/git/dotfiles/zprofile ~/.zprofile
	if [ -L ~/.prettierrc.json ]; then
		mv ~/.prettierrc.json ~/.prettierrc.json.premngyuan
	fi
	ln -s ~/git/dotfiles/prettierrc.json ~/.prettierrc.json
	if [ -L ~/.alacritty.yml ]; then
		mv ~/.alacritty.yml ~/.alacritty.yml.premngyuan
	fi
	ln -s ~/git/dotfiles/alacritty.yml ~/.alacritty.yml
	if [ -L ~/.hammerspoon/init.lua ]; then
		mv ~/.hammerspoon/init.lua ~/.hammerspoon/init.lua.premngyuan
	fi
	ln -s ~/git/dotfiles/hammerspoon_init.lua ~/.hammerspoon/init.lua


	# get git helpers
	mkdir ~/bin
	cd ~/bin && curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o git-prompt.sh
	cd ~/bin && curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o git-completion.bash
	cd ~/bin && curl -X GET https://raw.githubusercontent.com/holman/spark/master/spark -o spark
	cd ~/bin && curl https://raw.githubusercontent.com/felipec/git-remote-hg/master/git-remote-hg -o git-remote-hg
	chmod +x ~/bin/*


	if [[ "$(uname)" == Darwin* ]]; then
		# make keys repeat properly
		defaults write -g ApplePressAndHoldEnabled -bool false
		# just kidding, i'll set the minimum allowed because 10/1 is way too fast
		defaults write -g InitialKeyRepeat -int 15 # normal minimum is 15 (225 ms)
		defaults write -g KeyRepeat -int 2 # normal minimum is 2 (30 ms)
		# get brew
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		brew doctor
		# for compiling YCM
		brew install cmake
		# for better git
		brew install git
		# node
		brew install node
		# htop > top
		brew install htop-osx
		# for deoplete
		brew install python3
		brew link --overwrite python3
		# for j
		brew install autojump
		# for mosh
		brew install mobile-shell
		# for tmux
		brew install tmux
		# for battery in tmux statusline
		brew tap Goles/battery
		brew install battery
		# for glorious debugging, except gdb on mac sucks
		brew install cgdb
		# nvim has THREADS welcome to 2004
		brew install neovim
		brew install yarn
		# for deoplete
		npm -g install neovim
		# from vim8 with python3
		brew install vim
		# forget iTerm2
		brew install --cask alacritty
		# for window tiling
		brew install --cask hammerspoon
	fi


	echo "************** INSTALL COMPLETE **************"
	echo "you're also going to want:"
	echo "Karabiner Elements for 87U numlock / to remap capslock"
	echo "Native Display Brightness"
	echo "Chrome / HammerSpoon / Google Drive / Adobe CC"
	echo "~/git/dotfiles/terminfo"
}

part_one
