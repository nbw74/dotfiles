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

    pkginstall

    dotup
    submodules
    lnk

    echo_ok
}

dotup() {

    cd $HOME/.dotfiles

    echo_info "git pull on .dotfiles"
    git pull
}

submodules() {

    cd ${HOME}/.dotfiles

    local submodules_list=$(git submodule status)

    if [[ -z $submodules_list ]]; then
        echo_warn "No submodules found!"
        return 0
    fi

    echo "$submodules_list" | while read line; do
        typeset -a Sub=($line)

        if [[ ${Sub[0]} =~ -.* ]]; then
            echo_info "git submodule init ${Sub[1]}"
            git submodule init ${Sub[1]}
        fi

        echo_info "git submodule update ${Sub[1]}"
        git submodule update ${Sub[1]}

        unset Sub
    done

    [[ -d ${HOME}/.dotfiles/.vim/bundle/nerdtree-git-plugin ]] && rm -rf "${HOME}/.dotfiles/.vim/bundle/nerdtree-git-plugin"

}

pkginstall() {

    typeset -i redhat_distribution_major_version=0

    if [[ -r /etc/redhat-release ]]; then
        redhat_distribution_major_version=$(awk '{ match($0,"[.0-9]+",a) } END { print int(a[0]) }' /etc/redhat-release)
    fi

    if [[ ! -f /bin/zsh ]]; then
        echo_info "Installing packages..."
        if (( redhat_distribution_major_version >= 21 )); then
            sudo dnf install ${packages[*]}
        elif (( redhat_distribution_major_version > 0 )); then
            sudo yum install ${packages[*]}
        fi
    fi
}

lnk() {

    cd $HOME

    touch .viminfo

    for f in ${base[*]}; do
        if [[ ! -h $f ]]; then
            if [[ -e $f ]]; then
                mv $f ${f}-$(shuf -i 1000-9999 -n 1).bak
            fi

            echo_info_ln "ln -s $f"
            ln -s .dotfiles/$f $f
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
    cd $HOME
}

except() {
    ret=$?

    if (( ret )); then
        echo_err "ERROR ON LINE $LINENO"
        exit $ret
    fi
}

readonly C_RST="tput sgr0"
readonly C_RED="tput setaf 1"
readonly C_GREEN="tput setaf 2"
readonly C_YELLOW="tput setaf 3"
readonly C_BLUE="tput setaf 4"
readonly C_CYAN="tput setaf 6"
readonly C_WHITE="tput setaf 7"

echo_err() { $C_WHITE; echo "* ERROR: $*" 1>&2; $C_RST; }
echo_warn() { $C_YELLOW; echo "* WARNING: $*" 1>&2; $C_RST; }
echo_info() { $C_BLUE; echo "* INFO: $*" 1>&2; $C_RST; }
echo_info_ln() { $C_CYAN; echo "* INFO: $*" 1>&2; $C_RST; }
echo_ok() { $C_GREEN; echo "* OK" 1>&2; $C_RST; }

main
