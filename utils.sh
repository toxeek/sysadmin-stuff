[ "$UID" -ne "0" ] && echo "[+] you need to be r00t." >&2 && exit 1


APT="$(which apt-get)"
GREP="$(which grep)"
AWK="$(which awk)"

export __HEAD__ = "master"
export CWD=$(pwd)
export ROOT_DIR=$(dirname $CWD)
cfg_file="${ROOT_DIR}/sysadmin.cfg"

[ ! -f "$cfg_file" ] && echo "[+] sysadmin.cfg not found." >&2 && exit 1


###############
parsecfg() {
    local task="$1"
    local val="$($GREP $task $cfg_file | $AWK -F"=" '{print $2}')"
    [ "$val" -eq "1" ] && echo 1 || echo 0      
}

################
addUsertoGroup() {
    local WHO=$(who am i | awk '{print $1}')
    echo "[+] $WHO"
    local UGROUPS=$(groups $WHO | grep $1)
    echo "[+] UGROUPS: $UGROUPS"
    [ ! -n "$UGROUPS" ] && $(which usermod) -aG "$1" $WHO

    return $?
}
###############


