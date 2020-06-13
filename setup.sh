#/bin/bash -x

. chk_root.sh

typeset -a utils_array
typeset -a pentest_utils_array
typeset -a nmap_nse_utils_array

export utils_array="utils_array"
export pentest_utils_array="pentest_utils_array"
export nmap_nse_utils_array="nmap_nse_utils_array"

export REPO_NAME="sysadmin-stuff"
export CWD=$(pwd)
export REPO_ROOT_DIR=$(dirname $CWD)/${REPO_NAME}
export HOME_DIR="$HOME"
export UTILS_FILE="${REPO_ROOT_DIR}/utils.sh"
export PENTEST_UTILS_FILE="${REPO_ROOT_DIR}/pentest/utils.sh"
export NMAP_NSE_UTILS_FILE="${REPO_ROOT_DIR}/pentest/nmap-nse/utils.sh"
export HELPERS_FILE=${REPO_ROOT_DIR}/helpers.sh
# base utils in the array
export utils_array=(build-essential apt-transport-https software-properties-common unzip wget curl gnupg-agent ca-certificates tree)
export pentest_utils_array=()
export nmap_nse_utils_array=()

echo "[+] utils.sh path: $UTILS_FILE"
echo "[+] pentest utils.sh path: $PENTEST_UTILS_FILE"
echo "[+] repo root dir: $REPO_ROOT_DIR"
echo "[+] home dir: $HOME_DIR"

export cfg_file="${REPO_ROOT_DIR}/sysadmin.cfg"
export pentest_cfg_file="${REPO_ROOT_DIR}/pentest/pentest.cfg"
export nmap_nse_cfg_file="${REPO_ROOT_DIR}/pentest/nmap-nse/nse.cfg"
echo "[+] cfg file: $cfg_file"
echo
# export ansible_err_file="${REPO_ROOT_DIR}/ansible/error.log"
# export ansible_roles="(toxeek.docker)"
#####################
BASH=$(which bash)
APT="$(which apt-get)"
SNAP="$(which snap)"
AWK="$(which awk)"
CURL="$(which curl)"
WGET="$(which wget)"
#### pip3 ###########
apt-add-repository universe
${APT} update

$(which find) ${REPO_DIR} -name ".*sh" -exec chmod +x '{}' \;
[ ! -f "${UTILS_FILE}" ] && echo "[+] no utils file found." >&2 && exit 125

## update apt-get
echo "[+] updating apt-get .."
$APT "update" &>/dev/null
echo "[+] apt-get updated."
echo

## sourcing utils file
. ${UTILS_FILE}
. ${HELPERS_FILE}
. ${PENTEST_UTILS_FILE}
. ${NMAP_NSE_UTILS_FILE}

## add user to sudo group
##########
addUsertoGroup sudo
#########
## install sys goodies
#########
install_sys_utils
#########
install_pentest_utils
#########
install_nmap_nse_utils
#########
## add user to fuse group for sshfs
#########
# addUsertoGroup fuse ## not anymore for 20.04
#########




