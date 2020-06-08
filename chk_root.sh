
# you must be root
HOME_DIERCTORY=$(echo $(who am i) | awk '{print $1}')
[ "$UID" -ne "0" ]  && echo "[+] you need to be r00t." >&2 && exit 1
ROOT_DIR=$HOME_DIRECTORY