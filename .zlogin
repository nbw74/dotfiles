
uptime

if grep -Pq '(U_|_U)' "/proc/mdstat" 2>/dev/null
then
    echo -e '\e[1;31m* DEGRADED MDRAID DETECTED!\e[0m'
fi

export VISUAL=vim
export EDITOR=vim
export PAGER=less
export BROWSER=firefox

if hash kubectl 2>/dev/null
then
    source <(kubectl completion zsh)
fi

nodename=$(uname -n)

case ${nodename%%\.*} in
    nestor) eval $(keychain --eval id_dsa id_rsa)
        ;;
    admin1) eval $(keychain --eval id_dsa id_rsa)
        ;;
    ad0t|kino) eval $(keychain --eval id_rsa_kino)
        ;;
    fe04) eval $(keychain --eval id_rsa_fe04)
        ;;
    vs88|mtdi-zabbix-proxy) eval $(keychain --eval id_rsa)
	;;
    *) true
esac

unset nodename
