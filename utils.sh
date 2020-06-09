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
install_aws_cli() {
    $(which pip3) install awscli
}
################
install_sys_utils() {
    typeset -a system_utils
    system_utils=(build-essential tmux unzip apt-transport-https software-properties-common vscode wget curl sshfs gnupg-agent ca-certificates tree tcpdump python3 python3-pip strace tshark tfenv awslci docker docker-compose)
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
            ${SNAP} install --classic code
        elif [ "$util" == "awscli" ] ; then
            echo
            echo "[+] installing awscli .."
            echo
            $(which pip3) uninstall -y awscli &>/dev/null
            $(which pip3) install awscli 
        elif [ "$util" == "docker" ] ; then 
            echo
            if [[ ! $(which docker ) ]] ; then
                ${SNAP} install docker
                echo
                echo "[+] enabling and starting Docker via systemctl .."
                echo
            fi
        else
            ${APT} install -y ${util}
        fi
    done 
    echo
    echo "[+] installing virtualenvwrapper .."
    echo
    install_vritualenvwrapper
    echo
    echo "[~] all gooddies installed."
    echo

    return 0
}
################



