#/bin/bash -x

# we source the helper
. chk_root.sh

typeset -a utils_array
typeset -a pentest_utils_array
typeset -a nmap_nse_utils_array
typeset -a services_array
typeset -a devops_array

export REPO_NAME="sysadmin-stuff"
export CWD=$(pwd)
export REPO_ROOT_DIR=$(dirname $CWD)/${REPO_NAME}
export HOME_DIR="$HOME"
export LOCALSTACK_USER="$SUDO_USER"
export UTILS_FILE="${REPO_ROOT_DIR}/utils.sh"
export PENTEST_UTILS_FILE="${REPO_ROOT_DIR}/pentest/utils.sh"
export DEVOPS_UTILS_FILE="${REPO_ROOT_DIR}/devops/utils.sh"
export NMAP_NSE_UTILS_FILE="${REPO_ROOT_DIR}/pentest/nmap-nse/utils.sh"
export HELPERS_FILE=${REPO_ROOT_DIR}/helpers.sh
export SVC_MNGR_FILE="${REPO_ROOT_DIR}/services_mngr.sh"
# base utils in the array
export utils_array=(build-essential ssh git wget curl cmake pkg-config apt-transport-https software-properties-common unzip gnupg-agent ca-certificates tree)
export pentest_utils_array=(zlib1g zlib1g-dev libpq-dev libpcap-dev libsqlite3-dev ruby ruby-dev)
export nmap_nse_utils_array=()
export services_array=(etckeeper mariadb monit fail2ban docker)

echo "[+] utils.sh path: $UTILS_FILE"
echo "[+] pentest utils.sh path: $PENTEST_UTILS_FILE"
echo "[+] devops utils.sh path: $DEVOPS_UTILS_FILE"
echo "[+] repo root dir: $REPO_ROOT_DIR"
echo "[+] home dir: $HOME_DIR"

export cfg_file="${REPO_ROOT_DIR}/sysadmin.cfg"
export pentest_cfg_file="${REPO_ROOT_DIR}/pentest/pentest.cfg"
export devops_cfg_file="${REPO_ROOT_DIR}/devops/devops.cfg"
export nmap_nse_cfg_file="${REPO_ROOT_DIR}/pentest/nmap-nse/nse.cfg"

echo "[+] cfg file: $cfg_file"
echo
# export ansible_err_file="${REPO_ROOT_DIR}/ansible/error.log"
# export ansible_roles="(toxeek.docker)"
#####################
BASH=$(which bash)
APT="$(which apt)"
SNAP="$(which snap)"
AWK="$(which awk)"
CURL="$(which curl)"
WGET="$(which wget)"
#### pip3 ###########
apt-add-repository universe
${APT} update
echo "[!] do you want to do an apt-get ugrade? [y/n]"
read upgrade
if [[ "$upgrade" == *[yY]* ]]; then
    ${APT} -y upgrade
fi

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
. ${DEVOPS_UTILS_FILE}
. ${NMAP_NSE_UTILS_FILE}
. ${SVC_MNGR_FILE}

#########
## install sys goodies
#########
install_sys_utils
#########
install_devops_utils
#########
install_pentest_utils
#########
install_nmap_nse_utils
#########
utils_svc_mngr
## add user to sudo group
##########
addUsertoGroup sudo
#########






