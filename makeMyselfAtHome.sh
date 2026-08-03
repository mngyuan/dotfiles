#!/bin/bash
# requires git to exist
# symlinks vimrc, zshrc, tmux.conf, nvim, etc.
#
# Safe to re-run: every install / clone / symlink checks first.
# Deliberately no `set -e` -- a single missing brew formula shouldn't abort the
# whole run -- but every step is guarded so re-running is a no-op.

DOTFILES="$HOME/git/dotfiles"
DOTFILES_HTTPS="https://github.com/mngyuan/dotfiles.git"
DOTFILES_SSH="git@github.com:mngyuan/dotfiles.git"
BACKUP_SUFFIX="premngyuan"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

export HOMEBREW_NO_ASK=1
export HOMEBREW_NO_AUTO_UPDATE=1

# ---------- helpers ----------

have() { command -v "$1" >/dev/null 2>&1; }

skip() { echo "  skip: $*"; }

# clone_if_missing <repo url> <dest>
clone_if_missing() {
	local repo="$1" dest="$2"
	if [ -d "$dest/.git" ]; then
		skip "$dest is already a git repo"
	elif [ -e "$dest" ]; then
		echo "  WARNING: $dest exists but is not a git repo -- leaving it alone"
	else
		git clone "$repo" "$dest"
	fi
}

# back_up <path> -- moves an existing path out of the way, never overwriting an
# older backup
back_up() {
	local path="$1" dest="$1.$BACKUP_SUFFIX"
	if [ -e "$dest" ] || [ -L "$dest" ]; then
		dest="$dest.$(date +%Y%m%d%H%M%S)"
	fi
	echo "  backing up $path -> $dest"
	mv "$path" "$dest"
}

# link <src> <dest> -- symlink, backing up anything in the way. Handles the
# case where <dest> is a real file OR a real directory (plain `ln -s` would
# silently create the link *inside* an existing directory).
link() {
	local src="$1" dest="$2"
	if [ ! -e "$src" ]; then
		echo "  WARNING: $src does not exist, not linking $dest"
		return
	fi
	mkdir -p "$(dirname "$dest")"
	if [ -L "$dest" ]; then
		if [ "$(readlink "$dest")" = "$src" ]; then
			skip "$dest already links to $src"
			return
		fi
		back_up "$dest"
	elif [ -e "$dest" ]; then
		back_up "$dest"
	fi
	ln -s "$src" "$dest"
}

# fetch_bin <url> <filename> -- download into ~/bin once, chmod just that file
fetch_bin() {
	local url="$1" name="$2"
	mkdir -p "$HOME/bin"
	if [ -f "$HOME/bin/$name" ]; then
		skip "~/bin/$name already present"
		return
	fi
	if curl -fsSL "$url" -o "$HOME/bin/$name"; then
		chmod +x "$HOME/bin/$name"
	else
		echo "  WARNING: failed to fetch $name from $url"
		rm -f "$HOME/bin/$name"
	fi
}

brew_install() {
	for pkg in "$@"; do
		# accepts short or fully-qualified names; `brew list` wants the short one
		if brew list --formula "${pkg##*/}" >/dev/null 2>&1; then
			skip "brew formula ${pkg##*/}"
		else
			brew install "$pkg"
		fi
	done
}

brew_cask_install() {
	for pkg in "$@"; do
		if brew list --cask "$pkg" >/dev/null 2>&1; then
			skip "brew cask $pkg"
		else
			brew install --cask "$pkg"
		fi
	done
}

is_macos() { [ "$(uname)" = "Darwin" ]; }

# ---------- part one: packages, dotfiles repo, ssh, oh-my-zsh ----------

part_one () {
	if have apt-get; then
		echo "== apt packages =="
		# add-apt-repository lives in software-properties-common, so it has to
		# come *before* the PPA is added (was the other way round)
		if ! have add-apt-repository; then
			sudo apt-get install --assume-yes software-properties-common
		fi
		# neovim (more recent versions)
		if grep -rqs "neovim-ppa" /etc/apt/sources.list /etc/apt/sources.list.d 2>/dev/null; then
			skip "neovim PPA already added"
		else
			sudo add-apt-repository -y ppa:neovim-ppa/stable
			sudo apt-get update
		fi

		sudo apt-get install --assume-yes git curl vim tmux autojump htop cmake cgdb xclip zsh
		# python2 packages are gone from current Ubuntu; python3 only
		sudo apt-get install --assume-yes neovim python3-dev python3-pip python3-venv
		sudo apt-get install --assume-yes nodejs
	fi

	echo "== dotfiles repo =="
	mkdir -p "$HOME/git"
	clone_if_missing "$DOTFILES_HTTPS" "$DOTFILES"

	echo "== ssh key =="
	setup_ssh() {
		ssh-keygen -t ed25519
		echo "======= COPY BELOW THIS LINE FOR SETTING UP THIS KEY (on github) ======="
		cat "$HOME/.ssh/id_ed25519.pub"
		echo "======= COPY ABOVE THIS LINE FOR SETTING UP THIS KEY (on github) ======="
	}

	if ls "$HOME"/.ssh/id_*.pub >/dev/null 2>&1; then
		skip "an ssh public key already exists in ~/.ssh -- not generating another"
	else
		echo "Generate an ssh-key?"
		select yn in "Yes" "No"; do
			case $yn in
				Yes ) setup_ssh; break;;
				No ) echo "Ok. You may need to update the git remote in $DOTFILES if later you want to commit."; break;;
			esac
		done
	fi

	if ls "$HOME"/.ssh/id_*.pub >/dev/null 2>&1 && [ -d "$DOTFILES/.git" ]; then
		if [ "$(git -C "$DOTFILES" remote get-url origin 2>/dev/null)" = "$DOTFILES_SSH" ]; then
			skip "dotfiles origin already set to ssh"
		else
			git -C "$DOTFILES" remote set-url origin "$DOTFILES_SSH"
		fi
	fi

	echo "== oh-my-zsh =="
	# KEEP_ZSHRC stops the installer replacing a .zshrc we're about to symlink,
	# RUNZSH stops it launching an interactive zsh and killing the rest of this
	# script (which is why part_two used to have to be run by hand)
	if [ -d "${ZSH:-$HOME/.oh-my-zsh}" ]; then
		skip "oh-my-zsh already installed at ${ZSH:-$HOME/.oh-my-zsh}"
	else
		RUNZSH=no KEEP_ZSHRC=yes sh -c \
			"$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	fi

	part_two
}

# ---------- part two: plugins, symlinks, brew, editors ----------

part_two() {
	echo "== zsh / tmux plugins =="
	clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
	clone_if_missing https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
	clone_if_missing https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions"
	clone_if_missing https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

	echo "== symlinks =="
	# note: ~/.tmux.conf is no longer read by tmux 3.1+, config lives in
	# ~/.config/tmux/tmux.conf -- move an old one aside so it can't win
	if [ -e "$HOME/.tmux.conf" ] || [ -L "$HOME/.tmux.conf" ]; then
		back_up "$HOME/.tmux.conf"
	fi
	link "$DOTFILES/tmux.conf"       "$HOME/.config/tmux/tmux.conf"
	link "$DOTFILES/vimrc"           "$HOME/.vimrc"
	link "$DOTFILES/nvim"            "$HOME/.config/nvim"
	link "$DOTFILES/zshrc"           "$HOME/.zshrc"
	link "$DOTFILES/zshenv"          "$HOME/.zshenv"
	link "$DOTFILES/zprofile"        "$HOME/.zprofile"
	link "$DOTFILES/prettierrc.json" "$HOME/.prettierrc.json"
	link "$DOTFILES/biome.json"      "$HOME/.biome.json"

	if is_macos; then
		link "$DOTFILES/alacritty.toml"       "$HOME/.config/alacritty/alacritty.toml"
		link "$DOTFILES/hammerspoon_init.lua" "$HOME/.hammerspoon/init.lua"
	fi

	echo "== git helpers =="
	fetch_bin https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh git-prompt.sh
	fetch_bin https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash git-completion.bash
	fetch_bin https://raw.githubusercontent.com/holman/spark/master/spark spark
	fetch_bin https://raw.githubusercontent.com/felipec/git-remote-hg/master/git-remote-hg git-remote-hg

	if is_macos; then
		echo "== macos defaults =="
		# make keys repeat properly
		defaults write -g ApplePressAndHoldEnabled -bool false
		# just kidding, i'll set the minimum allowed because 10/1 is way too fast
		defaults write -g InitialKeyRepeat -int 15 # normal minimum is 15 (225 ms)
		defaults write -g KeyRepeat -int 2 # normal minimum is 2 (30 ms)

		echo "== homebrew =="
		if have brew; then
			skip "brew already installed at $(command -v brew)"
		else
			# NONINTERACTIVE=1 skips the "press RETURN to continue" prompt.
			# It cannot skip the sudo password prompt on a fresh machine.
			NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		fi
		# put brew on PATH for the rest of this script
		if ! have brew; then
			for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
				if [ -x "$candidate" ]; then
					eval "$("$candidate" shellenv)"
					break
				fi
			done
		fi

		if have brew; then
			brew doctor
			# for better git
			brew_install git
			# node
			brew_install node
			# htop > top  (htop-osx is long gone, plain htop works now)
			brew_install htop
			# for deoplete
			brew_install python3
			brew link --overwrite python3
			# for j
			brew_install autojump
			# for mosh
			brew_install mosh
			# for tmux
			brew_install tmux
			# for battery in tmux statusline.
			# goles/battery is a non-official tap, and tap trust is required by
			# default since brew 6.0.0. Installing the fully-qualified name
			# trusts just this one formula and taps implicitly, so no separate
			# `brew tap` / `brew trust` needed.
			brew_install goles/battery/battery
			# nvim has THREADS welcome to 2004
			brew_install neovim
			brew_install ripgrep # for telescope.nvim
			brew_install fzf # for tmux session switching
			brew_install tree-sitter tree-sitter-cli # for nvim
			brew_install yarn
			# from vim8 with python3
			brew_install vim
			# forget iTerm2
			brew_cask_install alacritty
			# for window tiling
			brew_cask_install hammerspoon
			# for key remapping
			brew_cask_install karabiner-elements
			# git delta
			brew_install git-delta

			# only claim the pager if something else hasn't already
			if [ -n "$(git config --global --get core.pager)" ]; then
				skip "git core.pager already set to '$(git config --global --get core.pager)'"
			else
				git config --global core.pager delta
			fi
			git config --global interactive.diffFilter 'delta --color-only'
			git config --global delta.navigate true
			git config --global delta.dark true  # or `delta.light true`, or omit for auto-detection
			git config --global merge.conflictStyle zdiff3
		else
			echo "  WARNING: brew still not on PATH, skipping brew packages"
		fi
	fi

	echo "== vim / nvim =="
	mkdir -p "$HOME/.vimundo"
	if [ -f "$HOME/.vim/autoload/plug.vim" ]; then
		skip "vim-plug already installed for vim"
	else
		curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
			https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	fi
	vim +PlugInstall +qall
	if [ -f "$HOME/.local/share/nvim/site/autoload/plug.vim" ]; then
		skip "vim-plug already installed for nvim"
	else
		curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
			https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	fi

	echo "************** INSTALL COMPLETE **************"
	echo "you're also going to want:"
	echo "open nvim once to let the plugin manager bootstrap"
	if is_macos; then
		echo "Karabiner Elements remap capslock"
		echo "Native Display Brightness"
		echo "Zen / Google Drive / Figma"
	fi
	echo "$DOTFILES/terminfo"
}

part_one
