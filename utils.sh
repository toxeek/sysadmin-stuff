[ "$UID" -ne "0" ] && echo "[+] you need to be r00t." >&2 && exit 1

export __HEAD__ = "master"

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


