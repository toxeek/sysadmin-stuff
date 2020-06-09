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
install_vritualenvwrapper() {
    if [[ ! $(which pip3) ]] ; then
        exit "[+] pip3 not installed? Exiting." && exit 125
    fi
    $(which pip3) install virtualenvwrapper
}
################
install_ansible_roles() {
    for role in ${ansible_roles[*]}; do
        $(which ansible-galaxy) install ${role} 
    done         
}
################
install_sys_utils() {
    typeset -a system_utils
    system_utils=(build-essential unzip apt-transport-https software-properties-common vscode wget curl sshfs tree tcpdump python3 python3-pip strace tshark python3 tfenv docker)
    for util in ${system_utils[*]}; do
        if [ "$util" == "tfenv" ] ; then
           mkdir -p /usr/local/bin 2>&1
           rm -rf ${HOME_DIR}/.tfenv
           git clone https://github.com/tfutils/tfenv.git ${HOME_DIR}/.tfenv &>/dev/null || exit 125
           ln -s ${HOME_DIR}/.tfenv/bin/* /usr/local/bin 2>/dev/null
           $(which tfenv) uninstall latest 2>/dev/null
           $(which tfenv) install latest 2>/dev/null
           if [[ ! $(which tfenv) ]] ; then
               echo "[+] tfenv installation problems. exiting" && exit 125
            fi
           echo
           echo "[+] switching to latest terraform version ..."
           echo
           $(which tfenv) use latest 2>/dev/null
           $(which tfenv) list 
        elif [ "$util" == "vscode" ] ; then 
            echo
            echo "[+] installing Visual Code Studio .."
            echo
            $(which snap) install --classic code
        elif [ "$util" == "docker" ] ; then 
            echo
            echo "[+] installing docker community edition .."
            echo
            ${CURL} -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
            $(which add-apt-repository) "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
            ${APT} update
            if [[ ! $(which docker ) ]] ; then
                ${APT} install docker
                echo
                echo "[+] enabling and starting Docker via systemctl .."
                echo
                systemctl enable docker
                systemctl daemon-reload docker
                systemctl start docker
            fi

        else
            ${APT} install -y ${util}
        fi
    done 
    echo
    echo "[+] installing virtualenvwrapper .."
    echo
    install_vritualenvwrapper
}
################



