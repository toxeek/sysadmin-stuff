
export CWD=$(pwd)
export ROOT_DIR=$(dirname $CWD)
echo "[+] root dir: $ROOT_DIR"
cfg_file="${ROOT_DIR}/sysadmin.cfg"
ansible_err_file="$ROOT_DIR/ansible/error.log"
system_utils="(sublime-text curl sshfs tree tcpdump tshark python python-boto mysql-client mysql-server python-mysqldb python-mysql.connector tfenv docker)"
ansible_roles="(toxeek.docker)"
#####################
APT="$(which apt-get)"
GREP="$(which grep)"
AWK="$(which awk)"
CURL="$(which curl)"
################
parsecfg() {
    local task="$1"
    local val="$($GREP $task $cfg_file | $AWK -F"=" '{print $2}')"
    (("$val" == "1")) && echo 1 || echo 0      
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
           git clone https://github.com/tfutils/tfenv.git ~/.tfenv
           ln -s ~/.tfenv/bin/* /usr/local/bin
        else
            ${APT} install -y ${util}
        fi 
        if [ "$util" == "docker" ] ; then 
            ${APT} install apt-transport-https ca-certificates curl software-properties-common
            ${CURL} -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
            $(which add-apt-repository) "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
            ${APT} update
            ${APT} install docker-ce
            systemctl enable docker
            systemctl daemo-reload docker
            systemctl start docker
        fi
    done 
}
################



