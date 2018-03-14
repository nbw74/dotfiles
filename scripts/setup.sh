#!/bin/bash
#
#

set -E
set -o nounset

# CONFIGURATION BEGIN
typeset -a base=( ".gitconfig" ".tmux.conf" ".vim" ".vimrc" ".zlogin" ".zlogout" ".zsh" ".zshrc" )
typeset mcdir=".config/mc"
typeset mcini="ini"
typeset -a dirs=( ".tmp" "$mcdir" )
typeset -a packages=( "zsh" "vim" "tree" )
# CONFIGURATION END

main() {
    local fn=${FUNCNAME[0]}

    trap 'except $LINENO' ERR

    pkginstall

    dotup
    submodules
    lnk
    attr

    echo_ok
}

dotup() {
    local fn=${FUNCNAME[0]}

    cd "$HOME/.dotfiles" || false

    echo_info "git pull on .dotfiles"
    git pull
}

submodules() {
    local fn=${FUNCNAME[0]}
    local submodules_list=""

    cd "${HOME}/.dotfiles" || false

    submodules_list=$(git submodule status)

    if [[ -z $submodules_list ]]; then
        echo_warn "No submodules found!"
        return 0
    fi

    echo "$submodules_list" | while read -r line; do
        typeset -a Sub=()
        mapfile -t Sub < <(echo "$line")

        if [[ ${Sub[0]} =~ -.* ]]; then
            echo_info "git submodule init ${Sub[1]}"
            git submodule init "${Sub[1]}"
        fi

        echo_info "git submodule update ${Sub[1]}"
        git submodule update "${Sub[1]}"

        unset Sub
    done

    if [[ -d ${HOME}/.dotfiles/.vim/bundle/nerdtree-git-plugin ]]; then
        rm -rf "${HOME}/.dotfiles/.vim/bundle/nerdtree-git-plugin"
    fi

}

pkginstall() {
    local fn=${FUNCNAME[0]}
    typeset -i redhat_distribution_major_version=0

    if [[ -r /etc/redhat-release ]]; then
        redhat_distribution_major_version=$(awk '{ match($0,"[.0-9]+",a) } END { print int(a[0]) }' /etc/redhat-release)
    fi

    if [[ ! -f /bin/zsh ]]; then
        echo_info "Installing packages..."
        if (( redhat_distribution_major_version >= 21 )); then
            sudo dnf install "${packages[@]}"
        elif (( redhat_distribution_major_version > 0 )); then
            sudo yum install "${packages[@]}"
        fi
    fi
}

lnk() {
    local fn=${FUNCNAME[0]}

    cd "$HOME" || false

    touch .viminfo

    for f in ${base[*]}; do
        if ! head "$f" | grep -Fqi 'pinned'; then
            if [[ ! -h $f ]]; then
                if [[ -e $f ]]; then
                    mv "$f" "${f}-$(shuf -i 1000-9999 -n 1).bak"
                fi

                echo_info_ln "ln -s $f"
                ln -s ".dotfiles/$f" "$f"
            fi
        fi
    done

    for d in ${dirs[*]}; do
        if [[ ! -d $d ]]; then
            mkdir -p "$d"
        fi
    done

    cd "${HOME}/$mcdir" || false
    if [[ ! -h $mcini ]]; then
        echo_info_ln "ln -sf $mcini"
        ln -sf ../../.dotfiles/${mcdir}/$mcini $mcini
    fi
    cd "$HOME" || false

}

attr() {
    local fn=${FUNCNAME[0]}
    local attrfile=".prompt.attr"

    cd "$HOME" || false

    if [[ ! -f /etc/bash.attr && ! -f $attrfile ]]; then
        cat > $attrfile << 'EOF'
# Username color (phy=GREEN, virt=CYAN)
PR_USER=${PR_BR_BLUE}
# Root user color (phy=RED, virt=YELLOW)
PR_ROOT=${PR_BR_BLUE}
# Hostname color (prod=RED, dev=GREEN, test=YELLOW, net=BLUE, localhost=MAGENTA)
PR_HOST=${PR_BR_RED}
EOF
    fi
}

except() {
    ret=$?

    if (( ret )); then
        echo_err "ERROR ON LINE $LINENO in function ${fn:-NULL}"
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
