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

if (( keyrun )); then
    eval $(keychain --nogui --eval ${keylist[*]})
fi

unset nodename keylist keyrun
