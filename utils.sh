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
}
################
install_vscode() {
    echo
    echo "[+] installing Visual Code Studio .."
    echo
    ${SNAP} install --classic code
}
################

install_sys_utils() {
    typeset -a system_utils
    system_utils=(build-essential tmux unzip apt-transport-https software-properties-common vscode wget curl sshfs gnupg-agent ca-certificates tree nginx tcpdump python3 python3-pip strace tshark tfenv awscli docker docker-compose portainer)
    for util in ${system_utils[*]}; do
        if [ "$util" == "tfenv" ] ; then
            install_tfenv
        elif [ "$util" == "vscode" ] ; then 
            install_vscode
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
        elif [ "$util" == "portainer" ]; then
            echo "[+] do you want Portainer installed, make sure you can (xinit, etc.) [y/n]"
            read portainer
            if [[ "$portainer" == *y ]] ; then
	        if echo 	
                ${APT} install xinit
                export DISPLAY=:0
            fi
            if [[ ! $(which startx) ]]; then
                    echo "[+] NO DISPLAY?" && exit 1
            else
                if [[ $(which docker) ]] ; then
                    $(which docker) volume create portainer_data
                    $(which docker) run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
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
                    firefox http://127.0.0.1:9000
            fi      
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



