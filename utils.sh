export REPO_NAME="sysadmin-stuff"
export CWD=$(pwd)
export ROOT_DIR=$(dirname $CWD)
echo "[+] root dir: $ROOT_DIR"
cfg_file="${ROOT_DIR}/sysadmin-stuff/sysadmin.cfg"
ansible_err_file="$ROOT_DIR/ansible/error.log"
typeset -a system_utils
system_utils="(apt-transport-https software-properties-common vscode wget curl sshfs tree tcpdump strace tshark python3 tfenv docker)"
ansible_roles="(toxeek.docker)"
#####################
APT="$(which apt-get)"
GREP="$(which grep)"
AWK="$(which awk)"
CURL="$(which curl)"
#### pip3 ###########
apt-add-repository universe
${APT} update
${APT} install python3-pip
################
parsecfg() {
    local task="$1"
    local val="$($GREP $task $cfg_file | $AWK -F"=" '{print $2}')"
    [[ "$val" -eq 1 ]] && echo 1 || echo 0      
}
################
addUsertoGroup() {
    local WHO=$(who am i | awk '{print $1}')
    local UGROUPS=$(groups $WHO | grep $1)
    [ ! -n "$UGROUPS" ] && $(which usermod) -aG "$1" $WHO

    return $?
}
################
install_ansible_roles() {
    for role in ${ansible_roles[*]}; do
        $(which ansible-galaxy) install ${role} 
    done         
}
################
install_sys_utils() {
    for util in ${system_utils[*]}; do
        if [ "$util" == "tfenv" ] ; then
           mkdir -p /usr/local/bin 2>&1
           rm -rf ${ROOT_DIR}/.tfenv
           git clone https://github.com/tfutils/tfenv.git ${ROOT_DIR}/.tfenv
           ln -sf ~/.tfenv/bin/* /usr/local/bin
        elif [ "$util" == "vscode" ] ; then 
            $(which snap) install --classic code
        elif [ "$util" == "docker-ce" ] ; then 
            ${APT} install apt-transport-https ca-certificates curl software-properties-common
            ${CURL} -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
            $(which add-apt-repository) "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
            ${APT} update
            ${APT} install docker-ce
            systemctl enable docker
            systemctl daemo-reload docker
            systemctl start docker
        else
            ${APT} install -y ${util}
        fi 
    done 
}
################



