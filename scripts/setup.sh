#!/bin/bash
#
#

set -E
set -o nounset

# DEFAULTS BEGIN
OPT_SUBMODULES=0
# DEFAULTS END

# CONFIGURATION BEGIN
typeset -a base=( ".gitconfig" ".tmux.conf" ".vim" ".vimrc" ".zlogin" ".zlogout" ".zsh" ".zshrc" )
typeset mcdir=".config/mc"
typeset mcini="ini"
typeset -a dirs=( ".tmp" "$mcdir" )
typeset -a packages=( "zsh" "vim" "tree" )
typeset -a packages_legacy=( "virt-what" )
typeset bn="$(basename "$0")"
# CONFIGURATION END

main() {
    local fn=${FUNCNAME[0]}

    trap 'except $LINENO' ERR

    pkginstall

    dotup

    if (( OPT_SUBMODULES )); then
	submodules
    fi

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
        read -r -a Sub <<< "$line"

        if [[ ${Sub[0]} =~ -.* ]]; then
            echo_info "git submodule init ${Sub[1]}"
            git submodule init "${Sub[1]}"
        fi

        echo_info "git submodule update ${Sub[1]}"
        git submodule update "${Sub[1]}"

        unset Sub
    done

    echo_info "Pull for all submodules:"
#     git submodule foreach "(git checkout master; git pull)"
    git pull --recurse-submodules

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
            sudo yum install "${packages[@]}" "${packages_legacy[@]}"
        fi
    fi
}

lnk() {
    local fn=${FUNCNAME[0]}
    local -i pinned=0

    cd "$HOME" || false

    touch .viminfo

    for f in ${base[*]}; do
        if [[ -f "$f" ]]; then
            if head "$f" | grep -Fqi 'pinned'; then
                pinned=1
            fi
        fi

        if (( ! pinned )); then
            if [[ ! -h $f ]]; then
                if [[ -e $f ]]; then
                    mv "$f" "${f}-$(shuf -i 1000-9999 -n 1).bak"
                fi

                echo_info_ln "ln -s $f"
                ln -s ".dotfiles/$f" "$f"
            fi
        fi

        pinned=0
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
    local -i is_virtualized=0

    if [[ -f /etc/bash.attr || -f $attrfile ]]; then
	return
    fi

    if command -v systemctl >/dev/null
    then
	if sudo systemd-detect-virt -q
	then
	    is_virtualized=1
	fi
    else
	if [[ -n "$(sudo virt-what)" ]]; then
	    is_virtualized=1
	fi
    fi

    if (( is_virtualized )); then
	color_u=CYAN
	color_r=YELLOW
    else
	color_u=GREEN
	color_r=RED
    fi

    PS3="Please specify the environment for colorization hostname in the prompt: "

    select env in production development testing auxiliary localhost
    do
	case $env in
	    production)
		color_e=RED
		break
		;;
	    development)
		color_e=GREEN
		break
		;;
	    testing)
		color_e=YELLOW
		break
		;;
	    auxiliary)
		color_e=BLUE
		break
		;;
	    localhost)
		color_e=MAGENTA
		break
		;;
	    *)
		echo_warn "Please try again."
	esac
    done

    cd "$HOME" || false

    cat > $attrfile <<EOF
# Username color (phy=GREEN, virt=CYAN)
PR_USER=\$PR_BR_$color_u
# Root user color (phy=RED, virt=YELLOW)
PR_ROOT=\$PR_BR_$color_r
# Hostname color (production=RED, testing=GREEN, staging=YELLOW, auxiliary=BLUE, localhost=MAGENTA)
PR_HOST=\$PR_BR_$color_e
EOF
}

usage() {
    echo -e "\\n    Usage: $bn [OPTIONS]\\n
    Options:

    -s, --submodules	    also update Git submodules
    -h, --help              print help
"
}

except() {
    ret=$?

    if (( ret )); then
        echo_err "ERROR ON LINE $LINENO in function ${fn:-NULL}"
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

# Getopts
getopt -T; (( $? == 4 )) || { echo "incompatible getopt version" >&2; exit 4; }

if ! TEMP=$(getopt -o sh --longoptions submodules,help -n "$bn" -- "$@")
then
    echo "Terminating..." >&2
    exit 1
fi

eval set -- "$TEMP"
unset TEMP

while true; do
    case $1 in
	-s|--submodules)	OPT_SUBMODULES=1 ;	shift	;;
	-h|--help)		usage ;		exit 0	;;
	--)			shift ;		break	;;
	*)			usage ;		exit 1
    esac
done

main
