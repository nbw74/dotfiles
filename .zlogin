#
# setxkbmap -layout "us,ru" -variant "winkeys" -option "grp:ctrl_shift_toggle"
#

uptime

### RAID STATUS
#
MDSTAT="/proc/mdstat"

GREP_COLOR='1;31';
if grep -P -B1 '(U_|_U)' $MDSTAT 2>/dev/null
then
    echo "--"
fi

GREP_COLOR='1;34';
grep -F -B1 'UU' $MDSTAT 2>/dev/null
# echo

export VISUAL=vim
export EDITOR=vim
export PAGER=less
export BROWSER=firefox

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
