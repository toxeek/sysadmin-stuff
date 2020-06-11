################
parsecfg() {
    local task="$1"
    local val="$(grep $task $cfg_file | $AWK -F"=" '{print $2}')"
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
    echo "[+] installing virtualenvwrapper .."
    echo
    if [[ ! $(which pip3) ]] ; then
        exit "[+] pip3 not installed? Exiting." && exit 125
    fi
    $(which pip3) install virtualenvwrapper

    return 0
}
################
install_ansible_roles() {
    for role in ${ansible_roles[*]}; do
        $(which ansible-galaxy) install ${role} 
    done    

    return 0     
}
################
install_aws_cli() {
    $(which pip3) install awscli
}
################
install_ansible() {
    echo "[+] install ansible? [y/n]"
    read ansible
    if [[ "$ansible" == *y* ]]; then
        ${APT} install -y ansible
    else :
    fi

    return 0
}
################

install_tfenv() {
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

    return 0
}
################
install_vscode() {
    echo
    echo "[+] installing Visual Code Studio .."
    echo
    ${SNAP} install --classic code

    return 0
}
################
install_portainer() {
    echo "[+] do you want Portainer installed, make sure you can (xinit, etc.) [y/n]"
    read portainer
    if [[ "$portainer" == *y ]] ; then	
        is_port_installed="$($(which docker) images | grep portainer)"
        if [ -n "$is_port_installed" ] ; then 
            echo "[+] Portainer seems to be running. passing.."  && return 1
        fi
        term_type="$(tty)"
        if echo "$term_type" | grep -q "pts"; then
            echo "[+] we are may be on a ssh terminal, exiting."  && return 1
        else
            ${APT} install xinit
            export DISPLAY=:0
        fi
            
        if [[ $(which docker) ]] ; then
            $(which docker) volume create portainer_data 2>/dev/null
            $(which docker) run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer 2>/dev/null
            # I do not have any royalties with FF!
            ${APT} install firefox &>/dev/nul
            apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A6DCF7707EBC211F
            apt-add-repository "deb http://ppa.launchpad.net/ubuntu-mozilla-security/ppa/ubuntu focal main"
            ${APT} update
            echo "[+] to run portainer just do: firefox 127.0.0.1:9000"
            echo "[+] or form your web browser: http://127.0.0.1:9000"
            echo
        fi
        echo "[+] do you want to run portainer now? [Y/N]"
        read runport
        if [[ "$runport" == *y ]] ; then
            $(which firefox) http://127.0.0.1:9000
        fi  
    else
        :
    fi
    
    return 0
}
################
install_awscli() {
    echo
    echo "[+] installing awscli .."
    echo
    $(which pip3) uninstall -y awscli &>/dev/null
    $(which pip3) install awscli 

    return 0
}
################
install_docker() {
    echo
    if [[ ! $(which docker ) ]] ; then
        ${SNAP} install docker
        echo
        echo "[+] enabling and starting Docker via systemctl .."
        echo
    fi

    return 0
}
################

install_sys_utils() {
    typeset -a system_utils
    system_utils=(build-essential tmux unzip apt-transport-https software-properties-common vscode wget curl sshfs gnupg-agent ca-certificates tree nginx tcpdump python3 python3-pip strace tshark tfenv ansible awscli virtualenvwrapper docker docker-compose portainer)
    for util in ${system_utils[*]}; do
        if [ "$util" == "tfenv" ] ; then
            install_tfenv
        elif [ "$util" == "vscode" ] ; then 
            install_vscode
        elif [ "$util" == "awscli" ] ; then
            install_awscli
        elif [ "$util" == "docker" ] ; then 
            install_docker
        elif [ "$util" == "ansible" ]; then
            install_ansible
        elif [ "$util" == "portainer" ]; then
            install_portainer
        elif [ "$util" == "virtualenvwrapper" ]; then
            install_virtualenvwrapper
        else 
            echo 
            echo "[+] installing ${util} .."
            ${APT} -y install ${util}
        fi
    done
    echo
    echo
    echo "[~] all gooddies installed."
    echo

    return 0
}
################




