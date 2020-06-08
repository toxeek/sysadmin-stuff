
# you must be root
if [ "$UID" -ne "$EUID" ]; then
    ROOT_DIR="/home/$SUDO_USER"
else
    HOME_DIERCTORY="/root"
    [ "$UID" -ne "0" ]  && echo "[+] you need to be r00t." >&2 && exit 1
    ROOT_DIR=$HOME_DIRECTORY
fi