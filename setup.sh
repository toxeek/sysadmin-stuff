#/bin/bash -x

. chk_root.sh

export REPO_NAME="sysadmin-stuff"
export CWD=$(pwd)
export REPO_ROOT_DIR=$(dirname $CWD)/${REPO_NAME}
export HOME_DIR="$HOME"
export UTILS_FILE="${REPO_ROOT_DIR}/utils.sh"
# base utils in the array
export utils_array=(build-essential apt-transport-https software-properties-common unzip wget curl gnupg-agent ca-certificates tree)

echo "[+] utils.sh path: $UTILS_FILE"
echo "[+] repo root dir: $REPO_ROOT_DIR"
echo "[+] home dir: $HOME_DIR"

export cfg_file="${REPO_ROOT_DIR}/sysadmin.cfg"
echo "[+] cfg file: $cfg_file"
echo
# export ansible_err_file="${REPO_ROOT_DIR}/ansible/error.log"
# export ansible_roles="(toxeek.docker)"
#####################
APT="$(which apt-get)"
SNAP="$(which snap)"
AWK="$(which awk)"
CURL="$(which curl)"
#### pip3 ###########
apt-add-repository universe
${APT} update

[ ! -f "${UTILS_FILE}" ] && echo "[+] no utils file found." >&2 && exit 125

## update apt-get
echo "[+] updating apt-get .."
$APT "update" &>/dev/null
echo "[+] apt-get updated."
echo

$(which find) ${REPO_DIR} -name ".*sh" -exec chmod +x '{}' \;
. ${UTILS_FILE}
## add user to sudo group
##########
addUsertoGroup sudo
#########
## install sys goodies
#########
install_sys_utils
#########
## add user to fuse group for sshfs
#########
# addUsertoGroup fuse ## not anymore for 20.04
#########




