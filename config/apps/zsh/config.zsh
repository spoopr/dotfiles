# credit thevaluable.dev for a lot of this

#
# history settings
#
setopt HIST_SAVE_NO_DUPS


#
# automatically add to directory stack
#
setopt AUTO_PUSHD


#
# prompt
#
PROMPT='%(!.%F{#ff5050}.)[%n@%m] [%(4c %-2~/.../%2~ %~)]%(!.#%f.$) '
RPROMPT=''


#
# vim bindings
# 
bindkey -v
KEYTIMEOUT=1

# change cursor between normal and insert mode
zle-keymap-select() {
	if [[ ${KEYMAP} == vicmd ]]; then
		echo -ne '\e[2 q'
	elif [[ ${KEYMAP} == main ]] || 
		[[ ${KEYMAP} == viins ]] || 
		[[ ${KEYMAP} == '' ]]; then
		echo -ne '\e[6 q'
	fi
}
zle-line-init() {
	echo -ne '\e[6 q'
}

zle -N zle-keymap-select
zle -N zle-line-init
