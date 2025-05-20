# load the completion system
autoload -U compinit; compinit

# zstyle [pattern] [style] [...values]
# where [pattern] is
# :completion:[function]:[completer]:[command]:[argument]:[tag]

# set completers
zstyle ':completion:*' completer _extensions _complete _correct
