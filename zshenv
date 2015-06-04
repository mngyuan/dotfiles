# so that vim on ubuntu can pbcopy, since vim's commands open
# an nonlogin noninteractive shell
if [[ "$(uname)" != Darwin* ]]; then
  alias pbcopy="xclip -selection clipboard"
  alias pbpaste="xclip -selection clipboard -o"
fi

