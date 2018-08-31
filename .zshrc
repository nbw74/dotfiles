#
# Zsh configuration file
# Generated and adopted for WM by nbw 2007-2017
#
# Tags:
# g: grml.org zsh settings
# t: http://www.rayninfo.co.uk/tips/zshtips.html
#

PATH=/sbin:/usr/sbin:$PATH

manpath=(/usr/X11R6/man /usr/local/man /usr/share/man /usr/local/share/man /usr/man)
export MANPATH
# cdpath=(~)				# Search path for the cd command
fpath=(~/.zsh/completion $fpath)	# Where to look for autoloaded function definitions
#hosts=(`hostname` 10.1.0.1 10.1.0.2 10.0.0.1)	# Hosts to use for completion (see later zstyle)

# Some environment variables
# export MAIL=/var/spool/mail/$USERNAME
# export HELPDIR=/usr/local/lib/zsh/help  # directory for run-help function to find docs
# MAILCHECK=300
DIRSTACKSIZE=20
watch=(notme)                   # watch for everybody but me
LOGCHECK=300                    # check every 5 min for login/logout activity
WATCHFMT='%n %a %l from %m at %t.'

# TERM
if [[ $(tty) =~ /dev/tty[0-9]* ]]; then
    export TERM='linux'
else
    local tmp_TERM
    local tmp_terminfo_dir

    for t in screen-256color xterm-256color xterm rxvt linux; do
        if [[ -d /usr/share/terminfo ]]; then
            tmp_terminfo_dir=/usr/share/terminfo
        elif [[ -d /lib/terminfo ]]; then
            tmp_terminfo_dir=/lib/terminfo
        else
            break
        fi
        tmp_TERM=$(find $tmp_terminfo_dir -type f -name ${t})
        if [[ ! -z $tmp_TERM ]]; then
            TERM=${tmp_TERM##*\/}
            export TERM
            break
        fi
    done
fi

# misc files
# BC_FILE=~/.bc.extensions

export EDITOR=vim
export VISUAL=vim
export PAGER=less

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# History options
HISTFILE=~/.zhistory
HISTSIZE=20000
SAVEHIST=20000

if [[ -f "/etc/DIR_COLORS" ]]
then
    eval $(dircolors -b /etc/DIR_COLORS)
else
    eval $(dircolors -b)
fi

# Color variables
# regular:
BLACK='\e[0;30m'
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[0;33m'
BLUE='\e[0;34m'
MAGENTA='\e[0;35m'
CYAN='\e[0;36m'
WHITE='\e[0;37m'
# bold:
BR_BLACK='\e[1;30m'
BR_RED='\e[1;31m'
BR_GREEN='\e[1;32m'
BR_YELLOW='\e[1;33m'
BR_BLUE='\e[1;34m'
BR_MAGENTA='\e[1;35m'
BR_CYAN='\e[1;36m'
BR_WHITE='\e[1;37m'
#
CRESET='\e[0m'
BOLD='\e[1m'
UL='\e[4m'

# Prompt setup
setopt prompt_subst
# let's load colors into our environment, then set them
autoload colors zsh/terminfo
colors

for COLOR in RED GREEN WHITE YELLOW BLUE MAGENTA CYAN BLACK; do
    eval PR_$COLOR='%{$fg[${(L)COLOR}]%}'
    eval PR_BR_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
done
PR_BOLD="%{$bold_color%}"
PR_UL="%{$underline_color%}"
PR_RESET="%{$reset_color%}"

if [[ -x "/usr/bin/ccze" ]]
then
    CCZE='|ccze -A'
fi

typeset -i redhat_distribution_major_version=0
typeset -i debian_distribution_major_version=0

if [[ -r /etc/redhat-release ]]; then
    redhat_distribution_major_version=$(awk '{ match($0,"[.0-9]+",a) } END { print int(a[0]) }' /etc/redhat-release)
fi

if [[ -r /etc/debian_version ]]; then
    debian_distribution_major_version=$(awk '{ match($0,"[0-9]+"); exit } END { print substr( $0, RSTART, RLENGTH ) }' /etc/debian_version)
fi

#g#
GRML_OSTYPE=$(uname -s)

islinux(){
    [[ $GRML_OSTYPE == "Linux" ]]
}

isfreebsd(){
    [[ $GRML_OSTYPE == "FreeBSD" ]]
}

#g# creates an alias and precedes the command with
# sudo if $EUID is not zero.
salias() {
    emulate -L zsh
    local only=0 ; local multi=0
    local key val
    while [[ $1 == -* ]] ; do
        case $1 in
            (-o) only=1 ;;
            (-a) multi=1 ;;
            (--) shift ; break ;;
            (-h)
                printf 'usage: salias [-h|-o|-a] <alias-expression>\n'
                printf '  -h      shows this help text.\n'
                printf '  -a      replace '\'' ; '\'' sequences with '\'' ; sudo '\''.\n'
                printf '          be careful using this option.\n'
                printf '  -o      only sets an alias if a preceding sudo would be needed.\n'
                return 0
                ;;
            (*) printf "unkown option: '%s'\n" "$1" ; return 1 ;;
        esac
        shift
    done

    if (( ${#argv} > 1 )) ; then
        printf 'Too many arguments %s\n' "${#argv}"
        return 1
    fi

    key="${1%%\=*}" ;  val="${1#*\=}"
    if (( EUID == 0 )) && (( only == 0 )); then
        alias -- "${key}=${val}"
    elif (( EUID > 0 )) ; then
        (( multi > 0 )) && val="${val// ; / ; sudo }"
        alias -- "${key}=sudo ${val}"
    fi

    return 0
}
# Set up aliases
alias cp='nocorrect cp'			# no spelling correction on cp
alias mv='nocorrect mv'			# no spelling correction on mv
alias mkdir='nocorrect mkdir'		# no spelling correction on mkdir
alias j=jobs
alias d='dirs -v'
alias h=history
alias dicker=docker
#g#
alias mdstat='cat /proc/mdstat'
alias ...='cd ../../'
alias ....='cd ../../../'
# git
alias gpl='git pull'
alias gps='git push'
alias gcm='git commit -m'
alias gco='git checkout'
alias gst='git status'

if (( redhat_distribution_major_version >= 21 )); then
    salias ds="dnf search"
    salias di="dnf install"
    salias de="dnf erase"
    salias up="dnf upgrade"
    # Fallback
    salias ys="dnf search"
    salias yi="dnf install"
    salias ye="dnf erase"
elif (( redhat_distribution_major_version > 0 )); then
    salias ys="yum search"
    salias yi="yum install"
    salias yli="yum localinstall"
    salias ylin="yum localinstall --nogpgcheck"
    salias ye="yum erase"
    salias up="yum upgrade"
    salias ups="yum --security upgrade"
fi
#
local -i a=0
for a in {1..20}
do
    alias $a="cd -$a"
done
unset a
#
local lsgdf="--group-directories-first"
# fallback if old RHEL
if (( redhat_distribution_major_version <= 5 )); then
    lsgdf=""
fi

alias ls="ls -C --color=always --classify --size -k --human-readable $lsgdf"
unset lsgdf
# ls -l с цифровым видом прав
alias lsd="ls -l | sed -e 's/--x/1/g' -e 's/-w-/2/g' -e 's/-wx/3/g' -e 's/r--/4/g'  -e 's/r-x/5/g' -e 's/rw-/6/g' -e 's/rwx/7/g' -e 's/---/0/g'"
alias tree='tree -aFqC'
alias df='df -PTh'
#g#a2# Remove current empty directory. Execute \kbd{cd ..; rmdir \$OLDCWD}
alias rmcdir='cd ..; rmdir $OLDPWD || cd $OLDPWD'

alias pe='sudo -Es'
alias se='sudoedit -E'
# alias dolog="vim -c ':$ !date \"+\%Y.\%m.\%d.\%H:\%M:\%S\"' /home/nbw/doc/slack.log"
alias ipt='for c in INPUT FORWARD OUTPUT INSSH; do iptables-save | grep -- "-A $c"| cat -n; printf '-%.0s' {1..80}; echo; done'
# Fast ping
if (( UID == 0 )); then
    local ping_interval=1
else
    local ping_interval=2
fi
alias ping="LC_ALL=en_US.UTF-8 ping -i0.${ping_interval} -W1 -c5"
unset ping_interval
# Global aliases -- These do not have to be at the beginning of the command line.
alias -g L='|&less'
alias -g C='|&ccze -A'
alias -g DN='/dev/null'
alias -g N='&> /dev/null' # No Output
alias -g NE='2> /dev/null' # No Errors
alias -g E='2>&1'
alias -g HE='2>>( sed -ue "s/.*/$fg_bold[red]&$reset_color/" 1>&2 )' # Highlight Errors
alias -g T='-t "tmux att || (sleep 2 && tmux new)"'
alias -g NC='| grep -Pv "(^$|^\s+$|^#|^\s+#)"'
alias -g P='-t "sudo -Es /usr/local/bin/eos -m passwd -u"'
alias -g ENC='| bzip2 -9 | base64 -w0'
# Informational aliases
alias info_openvz='echo -e "* if('''is_running''') {\n\e[1;33m\troot\e[0m;\n} elif('''is_not_running''') {\n\e[1;34m\tprivate\e[0m;\n}"'
alias info_colors='for i in {0..8} ; do printf "\x1b[0;38;5;${i}mcolour${i}\t\x1b[1;38;5;${i}mcolour${i}\n"; done'
alias info_pg_is_in_recovery='psql -Upostgres -AXtc "SELECT pg_is_in_recovery()"'
alias info_pg_replication='[[ $(psql -Upostgres -AXtc "SELECT pg_is_in_recovery()") == "t" ]] && \
    psql -Upostgres -Xc "SELECT now() - pg_last_xact_replay_timestamp() AS write_or_replication_delay" || \
    psql -Upostgres -Xc "SELECT client_addr, state, sent_location, write_location, flush_location, replay_location FROM pg_stat_replication;"'
alias info_pg_pgpass='echo -e "\e[37mhostname\e[0m:\e[37mport\e[0m:\e[37mdatabase\e[0m:\e[37musername\e[0m:\e[37mpassword\e[0m"'

# Use hard limits, except for a smaller stack and no core dumps
unlimit
limit stack 8192
limit core 0
limit -s

# Permissions for the new files
umask 022

# Autoload all shell functions from all directories in $fpath (following
# symlinks) that have the executable bit on (the executable bit is not
# necessary, but gives you an easy way to stop the autoloading of a
# particular shell function). $fpath should not be empty for this to work.
#for func in $^fpath/*(N-.x:t); autoload $func	!!!

bindkey "^f"  history-incremental-search-backward

#      Allows `>' redirection to truncate existing files, and  `>>'  to create files.  Otherwise `>!' or `>|' must be used 
#      to truncate a file, and `>>!' or `>>|' to create a file.
setopt clobber
#      Report the status of background jobs immediately, rather than waiting until just before printing a prompt
setopt notify
#      Try to correct the spelling of commands.  Note that, when the HASH_LIST_ALL option is not set or when some  directo-
#      ries in the path are not readable, this may falsely report spelling errors the first time some commands are used.
setopt correct
#      If  the  argument  to  a  cd command (or an implied cd with the AUTO_CD option set) is not a directory, and does not
#      begin with a slash, try to expand the expression as if it were preceded by a ‘~’)
setopt cdablevars
#      Do not require a leading ‘.’ in a filename to be matched explicitly.
setopt globdots
#      Have pushd with no arguments act like ‘pushd $HOME’.
setopt pushdtohome
#      Automatically list choices on an ambiguous completion.
setopt autolist
#      Try to correct the spelling of all arguments in a line.
# setopt correctall
#      If a command is issued that can’t be executed as a normal command, and the command is the name of a directory,  per-
#      form the cd command to that directory.
setopt autocd
#      In completion, recognize exact matches even if they are ambiguous.
setopt recexact
#      List jobs in the long format by default.
setopt longlistjobs
#      Treat single word simple commands without redirection as candidates for resumption of an existing job.
setopt autoresume
#      If  a new command line being added to the history list duplicates an older one, the older com-
#      mand is removed from the list (even if it is not the previous event).)
setopt histignorealldups
#      Do not enter command lines into the history list if they are duplicates of the previous event.
setopt histignoredups
#      Remove command lines from the history list when the first character on the line is a space, or
#      when one of the expanded aliases contains a leading space.
setopt histignorespace
#      Remove superfluous blanks from each command line being added to the history list.
###### setopt histreduceblanks
#      Remove function definitions from the history list.
setopt histnofunctions
#      Save each command’s beginning timestamp (in seconds since the epoch) and the duration (in sec-
#      onds) to the history file.
setopt extendedhistory
#      This  options  works like APPEND_HISTORY except that new history lines are added to the $HIST-
#      FILE incrementally (as soon as they are entered), rather than waiting until the  shell  exits.
setopt incappendhistory
#     This option both imports new commands from the history file, and also causes your  typed  com-
#     mands  to  be appended to the history file (the latter is like specifying INC_APPEND_HISTORY).
setopt sharehistory
#     Do not print the directory stack after pushd or popd.
setopt pushdsilent
#     Don’t push multiple copies of the same directory onto the directory stack.
setopt pushdignoredups
#     Make cd push the old directory onto the directory stack.
setopt autopushd
#     Exchanges  the  meanings  of ‘+’ and ‘-’ when used with a number to specify a directory in the
#     stack.
setopt pushdminus
#     Treat the ‘#’, ‘~’ and ‘^’ characters as part of patterns for filename generation,  etc.   (An
#     initial unquoted ‘~’ always produces named directory expansion.)
setopt extendedglob
#     Allow  the  character  sequence  ‘’’’  to signify a single quote within singly quoted strings.
#     Note this does not apply in quoted strings using the format $’...’, where a backslashed single
#     quote can be used.
setopt rcquotes
#     If  a  parameter  is  completed  whose content is the name of a directory, then add a trailing
#     slash instead of a space.
setopt autoparamslash
#
setopt printeightbit
setopt noflowcontrol
setopt interactive_comments

#     Run all background jobs at a lower priority.  This option is set by default.
unsetopt bgnice

# Autoload zsh modules when they are referenced
zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zmodload -ap zsh/mapfile mapfile
## менюобразная подсветка вариантов окончаний 
zmodload zsh/complist
zmodload zsh/regex

bindkey -e                 # emacs key bindings
# bindkey ' ' magic-space    # also do history expansion on space

# Bindings from Fedorchuck
# bindkey "^[[2~" yank
bindkey '^[[3~' delete-char
bindkey '^[[7~' beginning-of-line
bindkey '^[[8~' end-of-line
# bindkey '^[e' expand-cmd-path				## C-e for expanding path of typed command
#t# bind history to up down keys
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
# Fuckin' Debian and it's derivatives
bindkey '^[OA' up-line-or-beginning-search
bindkey '^[OB' down-line-or-beginning-search
# Reverse moving in menu completion
bindkey '^[[Z' reverse-menu-complete

# Setup new style completion system. To see examples of the old style (compctl
# based) programmable completion, check Misc/compctl-examples in the zsh
# distribution.
autoload -U compinit promptinit
compinit -u
promptinit

# http://linsovet.org.ua/zsh-auto-quoting-url
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# VCS information
# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Version-Control-Information
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:*' unstagedstr "✹"
zstyle ':vcs_info:*' stagedstr "✚"
zstyle ':vcs_info:git*' formats "${PR_RESET}(${PR_WHITE}%b:${PR_BR_YELLOW}%c${PR_BR_RED}%u${PR_BR_WHITE}%m${PR_RESET}) "
zstyle ':vcs_info:git*' actionformats "${PR_RESET}(${PR_WHITE}%b|${PR_BR_WHITE}%a:${PR_BR_YELLOW}%c${PR_BR_RED}%u${PR_BR_WHITE}%m${PR_RESET}) "

if ! whence precmd >/dev/null
then
    precmd () {
	vcs_info
    }
fi

# Completion Styles

# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'

# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=long-list select=0
zstyle ':completion:*' old-menu false
zstyle ':completion:*' original true
zstyle ':completion:*' substitute 1
zstyle ':completion:*' use-compctl true
zstyle ':completion:*' verbose true
zstyle ':completion:*' word true
zstyle ':completion:*' insert-tab false
zstyle ':completion:*:default' list-colors ${LS_COLORS}

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
## don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'
## чтобы видеть все процессы для kill или killall
zstyle ':completion:*:processes' command 'ps -xuf'
zstyle ':completion:*:processes' sort false
zstyle ':completion:*:processes-names' command 'ps xho command'
## add colors to processes for kill completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;32'

# Filename suffixes to ignore during completion (except after rm command)
#zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
#    '*?.old' '*?.pro'
# the same for old style completion
#fignore=(.o .c~ .old .pro)

# ignore completion functions (until the _ignored completer)
#zstyle ':completion:*:functions' ignored-patterns '_*'

# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath

# Шифрование каталога через openssl со сжатием
aesg() {
    tar -cf - "${@}" | gzip - | openssl aes-128-cbc -salt -out ${1}.tar.gz.aes
}
# Шифрование каталога через openssl без сжатия
aes() {
    tar -cf - "${@}" | openssl aes-128-cbc -salt -out ${1}.tar.aes
}
# Шифрование файла через openssl без сжатия
aesf() {
    openssl aes-128-cbc -salt -in "${1}" -out ${1}.grb
}
# Дешифровка сжатого каталога
aesgx() {
    openssl aes-128-cbc -d -salt -in "${1}" | gzip -dc | tar -x -f -
}
# Дешифровка несжатого каталога
aesx() {
    openssl aes-128-cbc -d -salt -in "${1}" | tar -x -f -
}
# Compile SELinux police module (.pp from .te) and load it
ppmodload() {
    local te=$1
    if [[ -z "$te" || ! -f "$te" ]] ; then
        echo "$0 - check, package and load SELinux non-base policy module" >&2
        echo "Usage: $0 <file.te>" >&2 ; return 1
    else
        checkmodule -M -m -o ${te%\.*}.mod $te && \
        semodule_package -o ${te%\.*}.pp -m ${te%\.*}.mod && \
        semodule -i ${te%\.*}.pp
    fi
}
#g# grep for running process, like: 'any vim'
any() {
    emulate -L zsh
    unsetopt KSH_ARRAYS
    if [[ -z "$1" ]] ; then
        echo "any - grep for process(es) by keyword" >&2
        echo "Usage: any <keyword>" >&2 ; return 1
    else
        #ps xauwww | grep -i "${grep_options[@]}" "[${1[1]}]${1[2,-1]}"
        ps xauwww | head -n 1
        ps xauwww | grep -i "[${1[1]}]${1[2,-1]}"
    fi
}
#g#f5# Backup \kbd{file_or_folder {\rm to} file_or_folder\_timestamp}
bk() {
    emulate -L zsh
    local current_date=$(date "+%FT%H%M%S%Z")
    local keep move verbose result
    usage() {
        cat << EOT
bk [-hcmv] FILE [FILE ...]
Backup a file or folder in place and append the timestamp

Usage:
-h    Display this help text
-c    Keep the file/folder as is, create a copy backup using cp(1) (default)
-m    Move the file/folder, using mv(1)
-v    Verbose

The -c and -m options can't be used at the same time. If both specified, the
last one is used.

The return code is the sum of all cp/mv return codes.
EOT
    }
    keep=1
    while getopts ":hcmv" opt; do
        case $opt in
            c) unset move && (( ++keep ));;
            m) unset keep && (( ++move ));;
            v) verbose="-v";;
            h) usage;;
            \?) usage >&2; return 1;;
        esac
    done
    shift "$((OPTIND-1))"
    if (( keep > 0 )); then
        while (( $# > 0 )); do
            if islinux; then
                cp $verbose -a "$1" "$1_$current_date"
            elif isfreebsd; then
                if [[ -d "$1" ]] && [[ "$1" == */ ]]; then
                    echo "cowardly refusing to copy $1 's content; see cp(1)" >&2; return 1
                else
                    cp $verbose -a "$1" "$1_$current_date"
                fi
            else;
                cp $verbose -pR "$1" "$1_$current_date"
            fi
            (( result += $? ))
            shift
        done
    elif (( move > 0 )); then
        while (( $# > 0 )); do
            mv $verbose "$1" "$1_$current_date"
            (( result += $? ))
            shift
        done
    fi
    return $result
}
# вызывается при изменении рабочего каталога
chpwd() { pwd; ls; }
#g#f5# Create Directoy and \kbd{cd} to it
mkcd() {
    if (( ARGC != 1 )); then
        printf 'usage: mkcd <new-directory>\n'
        return 1;
    fi
    if [[ ! -d "$1" ]]; then
        command mkdir -p "$1"
    else
        printf '`%s'\'' already exists: cd-ing.\n' "$1"
    fi
    builtin cd "$1"
}
#g#f5# Create temporary directory and \kbd{cd} to it
mkcdt() {
    local t
    t=$(mktemp -d)
    echo "$t"
    builtin cd "$t"
}
# От muhas
# быстрое переименование
name() {
    local name="$1"
    vared -c -p 'rename to: ' name
    command mv "$1" "$name"
}
#
src() {
    autoload -U zrecompile;
    [[ -f "~/.zshrc" ]] && zrecompile -p ~/.zshrc;
    [[ -f "~/.zcompdump" ]] && zrecompile -p ~/.zcompdump;
    [[ -f "~/.zshrc.zwc.old" ]] && rm -f ~/.zshrc.zwc.old;
    [[ -f "~/.zcompdump.zwc.old" ]] && rm -f ~/.zcompdump.zwc.old;
    source ~/.zshrc;
}
#g#
ssl_hashes=( sha512 sha256 sha1 md5 )
#g#
for sh in ${ssl_hashes}; do
    eval 'ssl-cert-'${sh}'() {
        emulate -L zsh
        if [[ -z $1 ]] ; then
            printf '\''usage: %s <file>\n'\'' "ssh-cert-'${sh}'"
            return 1
        fi
        openssl x509 -noout -fingerprint -'${sh}' -in $1
    }'
done; unset sh
#g#
ssl-cert-fingerprints() {
    emulate -L zsh
    local i
    if [[ -z $1 ]] ; then
        printf 'usage: ssl-cert-fingerprints <file>\n'
        return 1
    fi
    for i in ${ssl_hashes}
        do ssl-cert-$i $1;
    done
}
#g#
ssl-cert-info() {
    emulate -L zsh
    if [[ -z $1 ]] ; then
        printf 'usage: ssl-cert-info <file>\n'
        return 1
    fi
    openssl x509 -noout -text -in $1
    ssl-cert-fingerprints $1
}
#
ssl-web-info() {
    emulate -L zsh
    if [[ -z $1 ]] ; then
        printf 'usage: ssl-web-info <file>\n'
        return 1
    fi
    echo | openssl s_client -servername $1 -connect $1:443 2>/dev/null | openssl x509 -noout -issuer -subject -dates
}

#g#f2# Find history events by search pattern and list them by date.
whatwhen()  {
    emulate -L zsh
    local usage help ident format_l format_s first_char remain first last
    usage='USAGE: whatwhen [options] <searchstring> <search range>'
    help='Use `whatwhen -h'\'' for further explanations.'
    ident=${(l,${#${:-Usage: }},, ,)}
    format_l="${ident}%s\t\t\t%s\n"
    format_s="${format_l//(\\t)##/\\t}"
    # Make the first char of the word to search for case
    # insensitive; e.g. [aA]
    first_char=[${(L)1[1]}${(U)1[1]}]
    remain=${1[2,-1]}
    # Default search range is `-100'.
    first=${2:-\-100}
    # Optional, just used for `<first> <last>' given.
    last=$3
    case $1 in
        ("")
            printf '%s\n\n' 'ERROR: No search string specified. Aborting.'
            printf '%s\n%s\n\n' ${usage} ${help} && return 1
        ;;
        (-h)
            printf '%s\n\n' ${usage}
            print 'OPTIONS:'
            printf $format_l '-h' 'show help text'
            print '\f'
            print 'SEARCH RANGE:'
            printf $format_l "'0'" 'the whole history,'
            printf $format_l '-<n>' 'offset to the current history number; (default: -100)'
            printf $format_s '<[-]first> [<last>]' 'just searching within a give range'
            printf '\n%s\n' 'EXAMPLES:'
            printf ${format_l/(\\t)/} 'whatwhen grml' '# Range is set to -100 by default.'
            printf $format_l 'whatwhen zsh -250'
            printf $format_l 'whatwhen foo 1 99'
        ;;
        (\?)
            printf '%s\n%s\n\n' ${usage} ${help} && return 1
        ;;
        (*)
            # -l list results on stout rather than invoking $EDITOR.
            # -i Print dates as in YYYY-MM-DD.
            # -m Search for a - quoted - pattern within the history.
            fc -li -m "*${first_char}${remain}*" $first $last
        ;;
    esac
}
# 'DEC' function -- see also 'alias -g ENC'
DEC() {
    echo -n "$2" | base64 -d | bzip2 -dc > "$1"
}

[[ -f "$BC_FILE" ]] && export BC_ENV_ARGS="-ql $BC_FILE"
export LESS='-iMR -j5'
export GREP_COLOR='1;32'

# Ищем файл описания раскраски приглашения
if [[ -r "/etc/bash.attr" ]]; then
    source "/etc/bash.attr"
fi

if [[ -r "$HOME/.prompt.attr" ]]; then
    source "$HOME/.prompt.attr"
fi

[ -z $PR_CODE ] && PR_CODE=${PR_BLACK}
# Чорный цвѣтъ консоль намъ не покажетъ
[ "$PR_CODE" = "${PR_BR_BLACK}" ] && PR_CODE=${PR_RESET}
[ -z $PR_USER ] && PR_USER=${PR_WHITE}
[ -z $PR_ROOT ] && PR_ROOT=${PR_RED}
[ -z $PR_HOST ] && PR_HOST=${PR_BLUE}
[ -z $PR_ATTRIB ] && PR_ATTRIB=UNDEF
[ -z $PR_SRV_CODE ] || PR_SRV_CODE=-$PR_SRV_CODE

if [[ -n $MC_SID ]]; then
    PROMPT='${PR_BR_BLUE}%~${PR_RESET}> '
    RPROMPT=
    SPROMPT=
else
    PROMPT='%(?.${PR_RESET}.${PR_RED})%?${PR_RESET} \
%(!.${PR_ROOT}.${PR_USER})%n${PR_RESET}@${PR_HOST}%M${PR_RESET} ${PR_BR_BLUE}%2~\
${PR_RESET}%1(j.${PR_BR_RED}.)%#${PR_RESET} ${vcs_info_msg_0_:-}'
    RPROMPT=''
    SPROMPT=' ${PR_UL}Товарищ!${PR_RESET} Исправить ${PR_UL}'%R$'${PR_RESET} на ${PR_BOLD}'%r$'${PR_RESET}? ([y]да [${PR_UL}n${PR_RESET}]нет [a]пошёл на хуй [e]сам исправлю) _ '
fi

local -i NOHL=0

if (( debian_distribution_major_version && debian_distribution_major_version <= 6 )); then
    NOHL=1
fi

if (( ! NOHL )); then
    source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
    ZSH_HIGHLIGHT_STYLES[path]='fg=none,underline'
    ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')
    ZSH_HIGHLIGHT_PATTERNS+=('\*' 'fg=red,bold,bg=black')
    ZSH_HIGHLIGHT_PATTERNS+=('\|' 'fg=white,bold')
    # ZSH_HIGHLIGHT_PATTERNS+=('(group|host|hostgroup|hbacrule|hbacsvc|hbactest|krbtpolicy|passwd|pwpolicy|service|show|user)-' 'fg=white')
    #
fi

## EOF
