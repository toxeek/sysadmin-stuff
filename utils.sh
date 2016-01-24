
export CWD=$(pwd)
export ROOT_DIR=$(dirname $CWD)

################
function addUsertoGroup() {
    WHO=$(who am i | awk '{print $1}')
    echo "[+] $WHO"
    UGROUPS=$(groups $WHO | grep $1)
    echo "[+] UGROUPS: $UGROUPS"
    [ ! -n "$UGROUPS" ] && $(which usermod) -aG "$1" $WHO

    return $?
}
###############


