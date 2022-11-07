# exported variables, independent of shell, are present in ~/.profile

PS1='%(?.%(!.#.;).%F{6}%B;%b%f) '

goodnight(){
	ssh 192.168.0.99 "sudo poweroff"
	poweroff
}

gitroot(){
	"cd $(git rev-parse --show-toplevel)"
}

gitaap(){
	# git add amend push
	git add "$*" && git commit --amend --no-edit && git push -f
}

# returns filename if exists
# else /dev/null
filenameOrNull(){
	 [[ -e "$1" ]] && echo "$1" || echo "/dev/null"
}
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=$HISTSIZE
setopt appendhistory
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
local WORDCHARS=${WORDCHARS/\/}
setopt extended_glob
setopt +o nomatch
setopt interactivecomments

source ~/.virtualenv.zshrc

alias info info --vi-keys
alias logcat="adb logcat"
alias logcat="adb logcat"
alias ls='ls'
alias l='ls -l'
alias ll='ls -l'
alias lh='ls -lh'
alias rdp='xfreerdp /kbd:0x00010409 /w:1920 /h:1080 '
alias tempmail='firefox dropmail.me'
alias pgdb='/usr/bin/gdb -ex "source /usr/share/pwndbg/gdbinit.py"'
alias grep='/usr/bin/grep --color=auto'
alias greph="/usr/bin/grep -i --color=auto \
	--exclude-from='$HOME/.greph-exclude' \
	--exclude-from='$(filenameOrNull ./gitignore)' \
	--exclude-from='$(filenameOrNull ./.ignore)'"
alias xclip='xclip -r'
alias vi='vim --cmd "let vim_minimal=1" '
alias kubectl='kubectl --namespace=zamr-stg-limekit'
alias frida_dir='cd ~/CRED/tools/'

autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
setopt COMPLETE_ALIASES
zstyle ':completion::complete:*' gain-privileges 1
zstyle ':completion:*' completer _complete
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' '+l:|=* r:|=*'



#echo  -e "\e[4m\e[31m\e[1m################### Partial update triggred !!! Update now ! ################"
#sudo pacman -Syu

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[ShiftTab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"      beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"       end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"    overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}" backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"    delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"        up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"      down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"      backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"     forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"    beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"  end-of-buffer-or-history
[[ -n "${key[ShiftTab]}"  ]] && bindkey -- "${key[ShiftTab]}"  reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start {
		echoti smkx
	}
	function zle_application_mode_stop {
		echoti rmkx
	}
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

zshcache_time="$(date +%s%N)"

autoload -Uz add-zsh-hook

rehash_precmd() {
  if [[ -a /var/cache/zsh/pacman ]]; then
    local paccache_time="$(date -r /var/cache/zsh/pacman +%s%N)"
    if (( zshcache_time < paccache_time )); then
      rehash
      zshcache_time="$paccache_time"
    fi
  fi
}

add-zsh-hook -Uz precmd rehash_precmd


ttyctl -f


# enable vi mode
bindkey -v
export KEYTIMEOUT=1
# Show vi mode
# https://unix.stackexchange.com/a/1019/154333
function zle-line-init zle-keymap-select {
    RPS1="${${KEYMAP/vicmd/[NORMAL]}/(main|viins)/}"
    RPS2=$RPS1
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
# backspace must work always
bindkey -v '^?' backward-delete-char
# Reverse search
# source /usr/share/fzf/key-bindings.zsh
# source /usr/share/fzf/completion.zsh

# New terminal in current dir (ctrl+shift+t)
if [[ $TERM == xterm-termite ]]; then
	. /etc/profile.d/vte.sh
	__vte_osc7
fi
setopt autopushd


#ZSH_HIGHLIGHT_STYLES[path]='fg=white'
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_AUTOSUGGEST_USE_ASYNC=true
unsetopt share_history

# start-up
if [ "$TMUX" = "" ]; then tmux; fi

# ============= Mac specific =====================
export CLICOLOR=xterm-color
# export PATH=/opt/homebrew/bin:$PATH (in zprofile)
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
alias python='python3'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/opt/homerew/opt/vim/bin/vim:$PATH"
export PATH="/Users/neo/Library/Android/sdk/emulator:$PATH"
source ~/.profile
eval "$(pyenv init -)"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

unalias xclip
xclip(){
	pbcopy < $*
}

# =========== Cloud specific ==================
# autoload -Uz promptinit && promptinit
# prompt adam2
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
# echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
