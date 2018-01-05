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
typeset -a packages=( "zsh" "vim" "tree" )
# CONFIGURATION END

main() {

    trap 'except $LINENO' ERR

    typeset -i redhat_distribution_major_version=0

    if [[ -r /etc/redhat-release ]]; then
        redhat_distribution_major_version=$(awk '{ match($0,"[.0-9]+",a) } END { print int(a[0]) }' /etc/redhat-release)
    fi

    if [[ ! -f /bin/zsh ]]; then
        if (( redhat_distribution_major_version >= 21 )); then
            sudo dnf install ${packages[*]}
        elif (( redhat_distribution_major_version > 0 )); then
            sudo yum install ${packages[*]}
        fi
    fi

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

    touch .viminfo
}

except() {
    ret=$?

    if (( ret )); then
        echo "ERROR ON LINE $LINENO" 1>&2
    fi
}

main
