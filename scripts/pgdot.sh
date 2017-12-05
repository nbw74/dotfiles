#!/bin/bash
#
# Copy dotfiles for postgres user
#

readonly pghome="/var/lib/pgsql"

if (( UID )); then
    echo "This script must be run as superuser" 1>&2
    exit 1
fi

usermod -s /bin/zsh postgres

for i in .dotfiles .gitconfig .tmux.conf .vim .vimrc .zlogin .zlogout .zsh .zshrc; do
    cp -ai $i ${pghome}/
    chown -R postgres:postgres ${pghome}/$i
done

cat >> ${pghome}/.prompt.attr <<'EOF'
# Username color (phy=GREEN, virt=CYAN)
PR_USER=${PR_BR_CYAN}
# Root user color (phy=RED, virt=YELLOW)
PR_ROOT=${PR_BR_YELLOW}
# Hostname color (prod=RED, dev=GREEN, test=YELLOW, net=BLUE, localhost=MAGENTA)
PR_HOST=${PR_WHITE}
EOF
