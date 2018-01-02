#
# Zsh login configuration file
#

uptime

if grep -Pq '(U_|_U)' "/proc/mdstat" 2>/dev/null
then
    echo -e '\e[1;31m* DEGRADED MDRAID DETECTED!\e[0m'
fi

if hash kubectl 2>/dev/null
then
    source <(kubectl completion zsh)
fi

local nodename=$(uname -n)
local -i keyrun=1
local -a keylist

case ${nodename%%\.*} in
    nestor|admin1)
	keylist=( id_dsa id_rsa )
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
