#!/bin/bash
#
#


set -E
set -o nounset

typeset -a subrepos=( ".vim/bundle/nerdtree" ".vim/bundle/nerdtree-git-plugin" )

main() {

    trap 'except $LINENO' ERR

    cd $HOME/.dotfiles
    git pull

    for d in ${subrepos[*]}; do
        if [[ -d $HOME/.dotfiles/$d ]]; then
            cd $HOME/.dotfiles/$d
            git pull
        fi
    done
}

except() {
    ret=$?

    if (( ret )); then
        echo "ERROR ON LINE $LINENO" 1>&2
    fi
}

main
