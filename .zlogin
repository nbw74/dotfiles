#
# setxkbmap -layout "us,ru" -variant "winkeys" -option "grp:ctrl_shift_toggle"
#

uptime
echo
df -h 2>/dev/null|grep '\/$\|\/var$\|\/usr$\|\/tmp$\|\/boot$';
echo

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

case $(uname -n) in
    nestor.luna.webmechanic.ru) eval $(keychain --eval id_dsa id_rsa)
        ;;
    admin1.inside.webmechanic.ru) eval $(keychain --eval id_dsa id_rsa)
        ;;
    ad0t.inside.webmechanic.ru) eval $(keychain --eval id_rsa_kino)
        ;;
    fe04.inside.webmechanic.ru) eval $(keychain --eval id_rsa_fe04)
        ;;
    vs88.southbridge.ru) eval $(keychain --eval id_rsa)
	;;
    *) true
esac

