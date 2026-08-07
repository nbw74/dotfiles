#
# Zsh login configuration file
#

uptime

if grep -Pq '(U_|_U)' "/proc/mdstat" 2>/dev/null
then
    echo -e '\e[1;31m* DEGRADED MDRAID DETECTED!\e[0m'
fi

[ $commands[kubectl] ] && source <(kubectl completion zsh)

[[ -x /usr/local/go/bin/go ]] && export PATH=$PATH:/usr/local/go/bin

local nodename=$(hostname -s)
local fqdnhash=$(hostname -f | md5sum)
local -i keyrun=0
local -a keylist

if (( SHLVL > 1 )); then
    keyrun=1
elif [[ -n "$SSH_TTY" ]]; then
    keyrun=1
fi

case ${nodename%%\.*} in
    fe04)
	keylist=( id_rsa_fe04 id_ed25519 id_ecdsa_256 )
        ;;
    vs88)
	keylist=( id_rsa id_ed25519 )
	;;
    *)
	keyrun=0
esac

_copy_kube_config() {
    mkdir -m 0700 ~/.kube ;
    touch ~/.kube/config ;
    chmod 0600 ~/.kube/config ;
    sudo cat /root/.kube/config > ~/.kube/config ;
}

_copy_yc_config() {
    sudo cp -r /root/yandex-cloud ~/. ;
    sudo cp -r /root/.config/yandex-cloud ~/.config/. ;
    sudo chown `whoami`:`whoami` ~/yandex-cloud ~/.config/yandex-cloud ;
}

case "$fqdnhash" in
    182e373d2ba7ac910d4bc0ec39852e8b)
	_copy_kube_config ;
	_copy_yc_config
	;;
    3c1e18eb0fa554a1edcda50b5e28e53d)
	_copy_kube_config
	;;
    a4c1a5ceca5c4ddd9128bc571ee260aa)
	_copy_kube_config
	;;
    *)
	true
esac

if (( keyrun )); then
    eval $(keychain --nogui --eval ${keylist[*]})
fi

unset nodename keylist keyrun
