#/bin/bash -x

. chk_root.sh

export ROOT_DIR="$(pwd)"
## source utils.sh
export REPO_DIR="sysadmin-stuff"
UTILS_FILE="${ROOT_DIR}/utils.sh"

[ -e "${UTILS_FILE}" ] && . $UTILS_FILE || {
echo "[+] no utils file found." >&2 && exit 125
}

## we chmod +x all shell scripts
for m in $(find . -name "*.sh"); do
    chmod +x $m
done

## set PATH and modify ~/.bashrc 
CURRENT_PATH=$PATH
[[ ! $(grep "PATH=.*~/bin" ~/.bashrc) ]] && echo "export PATH=${PATH}:~/bin" >>~/.bashrc

## update apt-get
echo "[+] updating apt-get .."
$APT "update" &>/dev/null
echo "[+] apt-get updated."
echo

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
is_ansible="$(parsecfg 'ansible')"
if [ "$is_ansible" -eq "1" ]; then
## install ansible if enabled in cfg file
    echo "[+] dest dir: $ROOT_DIR/$REPO_DIR"
    mkdir -p "${ROOT_DIR}/${REPO_DIR}/ansible"
    touch "${ROOT_DIR}/${REPO_DIR}/ansible/error.log"
    ansible_err_file="${ROOT_DIR}/${REPO_DIR}/ansible/error.log"
    ${APT} install -y ansible 2>> $ansible_err_file
    ## execute ansible provision-localhost playbook
    ## $(which ansible-playbook) ${ROOT_DIR}/${REPO_DIR}/ansible/playbooks/provision-localhost.yml
else 
	## we just install custom binaries
	:

fi

###
$(which find) /home/${SUDO_USER} -name ".*sh" -exec chmod +x '{}' \;



