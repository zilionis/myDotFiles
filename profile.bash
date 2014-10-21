export PATH=/usr/local/bin:$HOME/bin:/usr/local/sbin:$PATH
export PATH=$(brew --prefix coreutils)/libexec/gnubin:$PATH

if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

git_branch() {
  # On branches, this will return the branch name
  # On non-branches, (no branch)
  ref="$(git symbolic-ref HEAD 2> /dev/null | sed -e 's/refs\/heads\///')"
  if [[ "$ref" != "" ]]; then
    echo "$ref "
  fi
}

# fastest possible way to check if repo is dirty
git_dirty() {
  # ✖
  if [[ -n "$(git status --porcelain 2> /dev/null)" ]]; then
    echo -n "$color_red"
    echo -n "✹"
  else 
  	echo -n "$color_green" 
  	echo -n "✔"
 fi
}

git_progress() {
  # Detect in-progress actions (e.g. merge, rebase)
  # https://github.com/git/git/blob/v1.9-rc2/wt-status.c#L1199-L1241
  git_dir="$(git rev-parse --git-dir)"

  # git merge
  if [[ -f "$git_dir/MERGE_HEAD" ]]; then
    echo "merge "
  elif [[ -d "$git_dir/rebase-apply" ]]; then
    # git am
    if [[ -f "$git_dir/rebase-apply/applying" ]]; then
      echo "am "
    # git rebase
    else
      echo "rebase "
    fi
  elif [[ -d "$git_dir/rebase-merge" ]]; then
    # git rebase --interactive/--merge
    echo "rebase "
  elif [[ -f "$git_dir/CHERRY_PICK_HEAD" ]]; then
    # git cherry-pick
    echo "cherry-pick "
  fi
  if [[ -f "$git_dir/BISECT_LOG" ]]; then
    # git bisect
    echo "bisect "
  fi
  if [[ -f "$git_dir/REVERT_HEAD" ]]; then
    # git revert --no-commit
    echo "revert "
  fi
}

# colors
color_bold="\[$(tput bold)\]"
color_reset="\[$(tput sgr0)\]"
color_red="\[$(tput setaf 1)\]"
color_green="\[$(tput setaf 2)\]"
color_yellow="\[$(tput setaf 3)\]"
color_blue="\[$(tput setaf 4)\]"
color_purple="\[$(tput setaf 5)\]"
color_teal="\[$(tput setaf 6)\]"
color_white="\[$(tput setaf 7)\]"
color_black="\[$(tput setaf 8)\]"

# Add git to the terminal prompt
git_prompt() {
  # Don't go any further if we're not in a git repo
  git rev-parse --is-inside-work-tree &> /dev/null || return

  # Stylize
  echo -n "❮ $color_bold$color_white"
  echo -n "± "
  echo -n $color_teal
  echo -n "$(git_branch)"
  echo -n $color_reset
  echo -n $color_purple
  echo -n "$(git_progress)"
  echo -n $color_reset
  echo -n "$(git_dirty)"
  echo -n $color_reset
  echo -n " ❯"
}



#
# brew install coreutils spark tree mc wget
#
#
#

## Customize the terminal input line
prompt() {
  #PS1="  ☁  $color_blue\W$color_reset $(git_prompt): "
  PS1="$color_white[ $color_yellow\u@\H ${color_red}\t$color_white ] $color_green\w$color_white $(git_prompt)$color_reset\n→ "
}

PROMPT_COMMAND=prompt

#Aliases

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -='cd -'        # Go back
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"

alias home="cd ~ && clear"

#alias ls="gls --color=auto -hF"

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
	colorflag="--color"
else # OS X `ls`
	colorflag="-G"
fi

alias ls="gls ${colorflag} -hF"
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

function mkd() {
	mkdir -p "$@" && cd "$@";
}



export CLICOLOR=1
#export LSCOLORS=ExFxCxDxBxegedabagacad