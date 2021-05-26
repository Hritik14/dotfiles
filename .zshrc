# exported variables, independent of shell, are present in ~/.profile
echo "Orphaned AUR packages"
echo "comm -23 <(pacman -Qqm | sort) <(curl https://aur.archlinux.org/packages.gz | gzip -cd | sort)
"

goodnight(){
	ssh 192.168.0.99 "sudo poweroff"
	poweroff
}

gitroot(){
	"cd $(git rev-parse --show-toplevel)"
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


alias info info --vi-keys
alias logcat="adb logcat"
alias logcat="adb logcat"
alias ls='ls --color=auto'
alias l='ls -l --color=auto'
alias ll='ls -l --color=auto'
alias lh='ls -lh --color=auto'
alias rdp='xfreerdp /kbd:0x00010409 /w:1920 /h:1080 '
alias tempmail='firefox dropmail.me'
alias open='mimeopen'
alias pgdb='/usr/bin/gdb -ex "source /usr/share/pwndbg/gdbinit.py"'
alias grep='/usr/bin/grep --color=auto'
alias greph="/usr/bin/grep -i --color=auto \
	--exclude-from='$HOME/.greph-exclude' \
	--exclude-from='$(filenameOrNull ./gitignore)' \
	--exclude-from='$(filenameOrNull ./.ignore)'"
alias xclip='xclip -r'

autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
setopt COMPLETE_ALIASES
zstyle ':completion::complete:*' gain-privileges 1
autoload -Uz promptinit
promptinit
prompt pure
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
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# New terminal in current dir (ctrl+shift+t)
if [[ $TERM == xterm-termite ]]; then
	. /etc/profile.d/vte.sh
	__vte_osc7
fi
setopt autopushd




# These line should be at the end of zshrc to work (docs say)
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_STYLES[path]='fg=white'
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_AUTOSUGGEST_USE_ASYNC=true
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^OC' forward-char
bindkey ';5C' forward-word
bindkey ';5D' backward-word
unsetopt share_history
