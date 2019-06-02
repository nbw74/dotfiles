#
# Zsh login configuration file
#

uptime

if grep -Pq '(U_|_U)' "/proc/mdstat" 2>/dev/null
then
    echo -e '\e[1;31m* DEGRADED MDRAID DETECTED!\e[0m'
fi

if command -v kubectl >/dev/null
then
    source <(kubectl completion zsh)
fi

local nodename=$(uname -n)
local -i keyrun=0
local -a keylist

if (( SHLVL > 1 )); then
    keyrun=1
elif [[ -n "$SSH_TTY" ]]; then
    keyrun=1
fi

case ${nodename%%\.*} in
    nestor)
	keylist=( id_dsa id_rsa )
        ;;
    admin1)
	keylist=( id_dsa id_rsa id_ed25519 )
        ;;
    kino)
	keylist=( id_rsa_wm id_ed25519 )
        ;;
    fe04)
	keylist=( id_rsa_fe04 id_ed25519 )
        ;;
    vs88|mtdi-zabbix-proxy)
	keylist=( id_rsa )
	;;
    knd-zbx-proxy)
	keylist=( id_ed25519 )
        ;;
    *)
	keyrun=0
esac

if (( keyrun )); then
    eval $(keychain --nogui --eval ${keylist[*]})
fi

unset nodename keylist keyrun
