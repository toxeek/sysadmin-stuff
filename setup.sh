#/bin/bash


## source utils.sh
UTILS_FILE="${ROOT_DIR}/utils.sh"


for m in $(find . -name ".sh"); do
    chmod +x $m
done

## set PATH and modify ~/.bashrc 
CURRENT_PATH=$PATH
[[ ! $(grep "PATH=.*~/bin" ~/.bashrc) ]] && echo "export PATH=${PATH}:~/bin" >>~/.bashrc

[ -e "${UTILS_FILE}" ] && . $UTILS_FILE || {
echo "[+] no utils file found." >&2 && exit 125
}

## update apt-get
echo "[+] updating apt-get .."
$APT "update" &>/dev/null
echo "[+] apt-get updated."
echo

## add user to sudo group
##########
addUsertoGroup sudo
#########

## install ansible
$ROOT_DIR/ansible/install.sh 2>>$ROOT_DIR/error.log

## install 

## execute all ansible playbooks
for m in ${ROOT_DIR}/ansible/playbooks/*yml; do
    echo "[+] installing $(echo $m | cut -d"_" -f2) .." 
    $(which ansible-playbook) $m &>/dev/null
done


###
chmod +x $HOME/bin/*



