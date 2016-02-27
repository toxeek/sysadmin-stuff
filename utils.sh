
APT="$(which apt-get)"
GREP="$(which grep)"
AWK="$(which awk)"

export CWD=$(pwd)
export ROOT_DIR=$(dirname $CWD)
cfg_file="${ROOT_DIR}/sysadmin.cfg"
ansible_err_file="$ROOT_DIR/ansible/error.log"


###############
parsecfg() {
    local task="$1"
    local val="$($GREP $task $cfg_file | $AWK -F"=" '{print $2}')"
    [ "$val" -eq "1" ] && echo 1 || echo 0      
}
################
addUsertoGroup() {
    local WHO=$(who am i | awk '{print $1}')
    local UGROUPS=$(groups $WHO | grep $1)
    [ ! -n "$UGROUPS" ] && $(which usermod) -aG "$1" $WHO

    return $?
}
###############


