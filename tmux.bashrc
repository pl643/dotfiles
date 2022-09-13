#### tmux.bashrc ####

# File is intended to be sourced from .bashrc
# Aliases and bash options
[ -f ~/repo/notes/aliases ] && source ~/repo/notes/aliases

# Bash options/bindings
shopt -s autocd  # allows changing folder without the cd command, just type folder name.
set -o vi

# bind '";;":vi-movement-mode'
bind '"; ":"\n"'
bind '";a":"fzf_run_alias\n"'
bind '";b":"cd -\n"'
bind '";c":"clear; check_git_repo\n"'
bind '";e":vi-movement-mode'
bind '";f":"~/repo/fzf-repl/fzf-repl.bash\n"'
bind '";g":"lazygit\n"'
bind '";h":"cd ~\n"'
bind '";n":"C news.com\n"'
bind '";r":"cd ~/repo\n"'
bind '";u":"cd ..\n"'
bind '";w":"cd ~/wsl\n"'
bind '";l":"ls -lhF --color\n"'
bind '";s":"ls -hF --color\n"'
bind '";S":"sba\n"'

bind -m vi-insert  -x '"\C-a": fzf_run_alias'
bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert 'Control-l: clear-screen'
bind -m vi-command '"\C-a": a'
bind -m vi-insert  '"\C-o": fzf_run_alias'

#SSHOPT="-o userknownhostsfile=/dev/null -o StrictHostKeyChecking=no -o LogLevel=quiet"  # these options prevent prompting
SSHOPT="-o userknownhostsfile=/dev/null -o StrictHostKeyChecking=no"  # these options prevent prompting
#export EDITOR='[ -f ~/df/init.vim ] || curl -Os https://raw.githubusercontent.com/pl643/kodekloud/main/init.vim && nvim -u ~/init.vim'

export DOTFILES='~/repo/dotfiles'
export EDITOR="nvim -u $DOTFILES/tmux.init.vim"
export VISUAL="$EDITOR"
tmux_bashrc="$DOTFILES/tmux.bashrc"

[ -d ~/.local/bin ] || mkdir -p ~/.local/bin && export PATH=~/.local/bin:$PATH
[ -d ~/repo/static-binaries ] && export PATH=~/repo/static-binaries:$PATH

# appends last issue command history to ~/.bash_history
export PROMPT_COMMAND="history -a; history -n; [ -f ~/.source ] && source ~/.source && rm ~/.source"

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
    builtin cd "$@" && echo "$@" >> ~/.cd_history && echo \> cd "$@" \; ls -lF --color=auto; ls -lF --color=auto
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
    save_pwd="$PWD"
    let total_repo=0
    let changed_count=0
    for gitrepo in $(find ~ -name .git); do
        builtin cd "$gitrepo/.."
        git fetch
        if ! git status | grep -qE "up to date|modified:" ; then
            let changed_count=(changed_count + 1)
            printf "\nRepo $changed_count: $(pwd)\n"
            git status
            alias "$changed_count"="builtin cd $PWD; lazygit"
        fi
        let total_repo=(total_repo + 1)
    done
    printf "\nTotal repositories found: $total_repo\n"
    builtin cd "$save_pwd"
}

# call if inside WSL environment
wsl_setup() {
    [ -d ~/wsl ] || mkdir ~/wsl
    cd ~/wsl
    if which wslvar > /dev/null; then
        [ -d ~/wsl/onedrive ] || ln -sf $(wslpath $(wslvar onedrive)) onedrive
        [ -d ~/wsl/home ] || ln -sf $(wslpath $(wslvar userprofile)) home
    fi
}

command_not_found_handle() { 
    selected=$(ls -1 | fzf --select-1 --query "$1")
    [ -z "$selected" ] && return 0
    if [ -d "$selected" ]; then
        # NOTE: add to enable cd: export PROMPT_COMMAND="[ -f ~/.source ] && source ~/.source && rm ~/.source"
        echo cd "\"$selected\"" > ~/.source
    else
        echo s="\"$selected\"" > ~/.source
        echo s="\"$selected\"" > ~/.source.DB
        extension="${selected##*.}"
        # echo command_not_found_handle: $selected
        case $extension in
            exe)
                evalstr='$selected'
                eval echo "> $evalstr"
                echo
                eval "$evalstr"
                ;;
            pl)
                evalstr='perl $selected'
                eval echo "\> $evalstr"
                echo
                eval "$evalstr"
                ;;
            ps1)
                evalstr='powershell.exe -ExecutionPolicy bypass -File $selected'
                eval echo "\> $evalstr"
                echo
                eval "$evalstr"
                ;;
            py)
                evalstr='python $selected'
                eval echo "\> $evalstr"
                echo
                eval "$evalstr"
                ;;
            sh)
                evalstr='bash $selected'
                eval echo "\> $evalstr"
                echo
                eval "$evalstr"
                ;;
            *)
                if [ -z $TMUX ]; then
                    echo s=\"$selected\"
                    echo s=\"$selected\" > ~/.source
                else
                    echo s=\"$selected\" -  ALT-v to paste
                    echo -n "$selected" | tmux load-buffer -
                    echo s=\"$selected\" > ~/.source
                fi
                ;;
        esac
    fi
}

# Aliases
alias a='alias'
alias apt='sd apt'
alias b='cd -'
alias C='"/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"'
alias cr="cd ~/repo"
alias cn="cd ~/repo/notes"
alias d="docker"
alias dr="docker run"
alias di="docker image"
alias dit="docker run -it"
alias e="$EDITOR"
alias fe="fzf_edit_function"
alias c='clear; check_git_repo'
alias g='lazygit'
alias gc='git clone'
alias gm='git commit -m'
alias h='cd ~'
alias ht='history'
alias l='echo \> ls -lhF; ls -lhF'   # long ls
alias la='echo \> ls -lAf ; ls -lAF'
alias lg='tmux list-keys | grep'
alias lazygit='lazygit -ucf ~/repo/dotfiles/tmux.lazygit.config.yaml'
alias ls='ls --color=auto'
alias rsync='rsync -e "ssh $SSHOPT"'
alias python='python3'
alias pwsh='powershell.exe'
alias s='echo \> ls -F ; ls -F'    # short ls
alias sa='ls -AF'
alias se='eval e \"$s\"'
alias sba="source $DOTFILES/tmux.bashrc"
alias scp="scp $SSHOPT"
alias sd='sudo'
alias ssh="ssh $SSHOPT"
alias ts='tmux source $DOTFILES/tmux.conf'
alias t="~/repo/static-binaries/tmux -2 -f $DOTFILES/tmux.conf"
alias ta='t attach || t'
alias tc='t source ~/repo/dotfiles/tmux.conf'
alias tl='t list-keys'
alias tr='l -tr'
alias u='cd ..'
alias T="nvim -u $DOTFILES/tmux.nvim.term -c \"term tmux attach\""
alias wa='alias | grep wsl'
alias wpath='wslpath'
alias wl='wsl.exe --list --ver'
alias wsl='wsl.exe'
alias wsl-distro='wsl.exe --distrobution'
alias wsl-list='wsl.exe --list --ver'
alias wsl-list-online='wsl.exe --list --online'
alias vi='echo NOTE: use e alias'
alias vlc='"/mnt/c/Program Files/VideoLAN/VLC/vlc.exe"'
which neofetch > /dev/null && neofetch
echo "NOTE: last line $tmux_bashrc"
