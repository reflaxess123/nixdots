export NPM_CONFIG_PREFIX="$HOME/.npm-global"
export PATH="$HOME/.npm-global/bin:$PATH"

# Install Claude Code if not present
if ! command -v claude-code &> /dev/null; then
  mkdir -p "$HOME/.npm-global"
  npm install -g @anthropic-ai/claude-code
fi


# Commands that should be applied only for interactive shells.
[[ $- == *i* ]] || return

HISTFILESIZE=100000
HISTSIZE=10000

shopt -s histappend
shopt -s checkwinsize
shopt -s extglob
shopt -s globstar
shopt -s checkjobs



if [[ ! -v BASH_COMPLETION_VERSINFO ]]; then
  . "/nix/store/p7pmqk7xndkzvaqrkw0kjrq4f746dlxs-bash-completion-2.16.0/etc/profile.d/bash_completion.sh"
fi

