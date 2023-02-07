#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
if [[ -f "${HOME}/.aliases" ]]; then
   source "${HOME}/.aliases"
fi

if [[ -f "${HOME}/.zshrc.local" ]]; then
    source "${HOME}/.zshrc.local"
fi

if [[ -f "/usr/share/fzf/shell/key-bindings.zsh" ]]; then
    source "/usr/share/fzf/shell/key-bindings.zsh"
fi

autoload -Uz bashcompinit && bashcompinit
