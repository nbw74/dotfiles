#!/bin/bash
#
#

set -E
set -o nounset

# CONFIGURATION BEGIN
typeset -a base=( ".gitconfig" ".tmux.conf" ".vim" ".vimrc" ".zlogin" ".zlogout" ".zsh" ".zshrc" )
typeset mcdir=".config/mc"
typeset mcini="ini"
typeset -a dirs=( ".tmp" $mcdir )
# CONFIGURATION END

main() {

    trap 'except $LINENO' ERR

    cd $HOME

    for f in ${base[*]}; do
        if [[ ! -h $f ]]; then
            ln -svf .dotfiles/$f $f
        fi
    done

    for d in ${dirs[*]}; do
        if [[ ! -d $d ]]; then
            mkdir -p $d
        fi
    done

    cd $mcdir
    if [[ ! -h $mcini ]]; then
        ln -svf ../../.dotfiles/.config/mc/$mcini $mcini
    fi
}

except() {
    ret=$?

    if (( ret )); then
        echo "ERROR ON LINE $LINENO" 1>&2
    fi
}

main
