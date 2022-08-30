#### tmux.bashrc ####

# File is intended to be sourced from .bashrc
# Aliases and bash options

# Bash options/bindings
shopt -s autocd  # allows changing folder without the cd command, just type folder name.
set -o vi

# bind '";;":vi-movement-mode'
bind '";e":vi-movement-mode'
bind '";.":";"'
bind '";c":"clear; check_git_repo\n"'
bind '";f":"~/repo/fzf-repl/fzf-repl.bash\n"'
bind '";a":"fzf_run_alias\n"'

bind '";p0":"ssh ply@pi0\n"'
#bind '";sb":"sba\n"'

bind '";gm":"git commit -m ""\ei'
bind '";gd":"git diff""\n'
bind '";gh":"git push""\n'
bind '";l":"ls -lhF --color\n"'
bind '";s":"ls -hF --color\n"'
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

export DOTFILES=~/repo/dotfiles
export EDITOR="nvim -u $DOTFILES/tmux.init.vim"
export VISUAL="nvim -u $DOTFILES/tmux.init.vim"
[ -d ~/.local/bin ]           && export PATH=~/.local/bin:$PATH
[ -d ~/repo/static-binaries ] && export PATH=~/repo/static-binaries:$PATH

# appends last issue command history to ~/.bash_history
export PROMPT_COMMAND="history -a; history -n"

# Functions

fail() {
  >&2 echo "$1"
  exit 2
}

# add to to ~/.bashrc
add_to_bashrc() {
    grep tmux.bashrc ~/.bashrc || echo source \~/repo/dotfiles/tmux.bashrc >> ~/.bashrc
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

check_git_repo() {
    let total_repo=0
    let changed_count=0
    for gitrepo in $(find ~ -name .git); do
        builtin cd "$gitrepo/.."
        if ! git status | grep -q "clean" > /dev/null; then
            let changed_count=(changed_count + 1)
            printf "\nRepo $changed_count: $(pwd)\n"
            git status
            alias "$changed_count"="builtin cd $PWD; lazygit"
        fi
        let total_repo=(total_repo + 1)
    done
    printf "\nTotal repositories found: $total_repo\n"
}

# Aliases
alias a='alias'
alias apt='sd apt'
alias b='cd -'
alias e="$EDITOR"
alias fe="fzf_edit_function"
alias c='clear; check_git_repo'
alias g='lazygit'
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
alias pwsh='powershell.exe'
alias s='echo \> ls -F ; ls -F'    # short ls
alias sa='ls -AF'
alias sba="source $DOTFILES/tmux.bashrc"
alias scp="scp $SSHOPT"
alias sd='sudo'
alias ssh="ssh $SSHOPT"
alias st='tmux source ./df/tmux.conf'
alias t="~/repo/static-binaries/tmux -2 -f $DOTFILES/tmux.conf"
alias ta='t attach || t'
alias tc='t source ~/repo/dotfiles/tmux.conf'
alias tl='t list-keys'
alias tr='l -tr'
alias u='cd ..'
alias wsl='wsl.exe'
alias wsl-distro='wsl.exe --distrobution'
alias wsl-list='wsl.exe --list --ver'
alias wsl-list-online='wsl.exe --list --online'
alias vi='echo NOTE: use e alias'
# add tmux_bashrc to ~/.bashrc -a
tmux_bashrc="$DOTFILES/tmux.bashrc"
which neofetch > /dev/null && neofetch
echo "NOTE: last line $tmux_bashrc"
