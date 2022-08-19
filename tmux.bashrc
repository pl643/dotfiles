#### tmux.bashrc ####

# File is intended to be sourced from .bashrc
# Aliases and bash options

# Bash options/bindings
shopt -s autocd  # allows changing folder without the cd command, just type folder name.
set -o vi

# bind '";;":vi-movement-mode'
bind '";e":vi-movement-mode'
bind '";.":";"'
bind '";f":"~/repo/fzf-repl/fzf-repl.bash\n"'
bind '";a":"fzf_run_alias\n"'

bind '";p0":"ssh ply@pi0\n"'
bind '";sb":"sba\n"'

bind '";gm":"git commit -m ""\ei'
bind '";gd":"git diff""\n'
bind '";gh":"git push""\n'
bind '";l":"ls -lF --color\n"'
#bind ';2":vi-movement-mode'
#bind ';l:"tmux popup -E ~/df/tmux-mapleader ,\n"'
bind -m vi-insert  -x '"\C-a": fzf_run_alias'
bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert 'Control-l: clear-screen'
bind -m vi-command '"\C-a": a'
bind -m vi-insert  '"\C-o": fzf_run_alias'
#bind 'Control-o: "> output"\n'

#SSHOPT="-o userknownhostsfile=/dev/null -o StrictHostKeyChecking=no -o LogLevel=quiet"  # these options prevent prompting
SSHOPT="-o userknownhostsfile=/dev/null -o StrictHostKeyChecking=no"  # these options prevent prompting
#export EDITOR='[ -f ~/df/init.vim ] || curl -Os https://raw.githubusercontent.com/pl643/kodekloud/main/init.vim && nvim -u ~/init.vim'

EDITOR="nvim -u ~/repo/dotfiles/tmux.init.vim"
[ -f ~/bin ] && export $PATH:~/bin:$PATH

# appends last issue command history to ~/.bash_history
export PROMPT_COMMAND="history -a; history -n"

# Functions

fail() {
  >&2 echo "$1"
  exit 2
}

# Select and execute alias with fzf
fzf_run_alias() {
	local sel a
	sel=$(alias|sed 's/alias //'|fzf)
	[ -z "$sel" ] || a="$(echo "$sel"|cut -f1 -d=)"
	echo \> $a
	eval $a
}

# https://unix.stackexchange.com/questions/20396/make-cd-automatically-ls
function cd {
    builtin cd "$@" && echo \> cd "$@" \; ls -lF ;  ls -lF
}

# Edit a file using fzf
fzf_edit_function() {
	fzf="$(command -v fzf 2> /dev/null)" || fzf="$(dirname "$0")/fzf"
	[[ -x "$fzf" ]] || fail 'fzf executable not found'
	if [ -z $1 ]; then
		fselected=$(find . -type f 2> /dev/null | fzf --height=20); [ -z $fselected ] || $EDITOR $fselected
	else
		fselected=$(find $1 -type f 2> /dev/null |fzf --height=20); [ -z $fselected ] || $EDITOR $fselected
	fi
}


# Aliases
alias a='alias'
alias apt='sd apt'
alias b='cd -'
alias e="$EDITOR"
alias fe="fzf_edit_function"
alias g='grep'
alias gc='git clone'
alias gm='git commit -m'
alias h='cd ~'
alias h='cd ~'
alias ht='history'
alias l='echo \> ls -lF; ls -lF'   # long ls
alias la='echo \> ls -lAf ; ls -lAF'
alias lg='tmux list-keys | grep'
alias ls='ls --color=auto'
alias rp="tmux popup -E -w 25 -h 12 'tmux-pane-resize.sh'"
alias rsync='rsync -e "ssh $SSHOPT"'
alias s='echo \> ls -F ; ls -F'    # short ls
alias sa='ls -AF'
alias sba='source ~/df/tmux.bashrc'
alias scp="scp $SSHOPT"
alias sd='sudo'
alias ssh="ssh $SSHOPT"
alias st='tmux source ./df/tmux.conf'
alias t='tmux -2 -f ~/df/tmux.conf'
alias ta='t attach'
alias tl='tmux list-keys'
alias tr='l -tr'
alias u='cd ..'
alias vi='echo NOTE: use e alias'
# add tmux_bashrc to ~/.bashrc -a
tmux_bashrc="$HOME/repo/dotfiles/bashrc.tmux"
#[ -f $bashrc_tmux ] && grep -q "bashrc.tmux" "$HOME/.bashrc" || echo "source ~/df/bashrc.tmux" >> $HOME/.bashrc
echo "NOTE: last line $tmux_bashrc"
