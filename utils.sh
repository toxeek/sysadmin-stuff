################
install_utils() {
    while read UTIL; do 
        util="$(echo $UTIL | $AWK -F"=" '{print $1}')"
        val="$(echo $UTIL | $AWK -F"=" '{print $2}')"
        if [[ "$util" == "terraform-version" ]] ; then
            export tf_version=$(echo $val | sed -e 's/"//g')
            result=$(awk -vn1="$val" -vn2="$tf_version" 'BEGIN{print (n1==n2)?1:0 }')
            [ "$result" == 1 ] && export ft_ver="true"
            echo "[+] Terraform version chosen: $tf_version"
            echo "[+} debugging tf_version: $val"
            val="$result"
        fi
        if [[ "$val" -eq "1" ]] || [ -n "$tf_ver" ] ; then 
            if [ "$util" != "terraform-version" ] ; then
                sleep 1 && echo "[~] adding $util to array .." && utils_array+=($util)
            fi
        fi
    done < $cfg_file

    # echo "[+] debugging array: $(echo ${utils_array[*]})"

    return 0
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
    echo
    echo "[+] installing virtualenvwrapper .."
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
    echo "[+] installing awscli .."
    $(which pip3) install awscli
}
################
install_ansible() {
    echo
    echo "[+] install ansible? [y/n]"
    read ansible
    if [[ "$ansible" == *y* ]]; then
        ${APT} install -y ansible
    else :
    fi

    return 0
}
################
install_htop() {
    if [[ $(which htop) ]]; then
        echo
        echo "[+] htop already installed, passing." && return 1
    else
        ${APT} install -y install htop
    fi

    return 0
}
################
install_virtualbox() {
    echo 
    echo "[+] detecting if we are in a VirtualBox Vm .."
    # remmember dmidecode is installed in Ubuntu 20.04 LTS 
    if dmidecode | grep -q -i virtualbox; then 
      echo "[+] VirtualBox running, as you are in one or have it.." 
      return 1
    else
    ${APT} install -y virtualbox
    fi

    return 0
}
################
install_tfenv() {
    echo 
    echo "[+] installing tfenv .."
    mkdir -p /usr/local/bin 2>&1
    rm -rf ${HOME_DIR}/.tfenv
    git clone https://github.com/tfutils/tfenv.git ${HOME_DIR}/.tfenv &>/dev/null || exit 125
    ln -s ${HOME_DIR}/.tfenv/bin/* /usr/local/bin 2>/dev/null
    # $(which tfenv) uninstall latest 2>/dev/null
    if [ ! -z "$tf_version" ]; then
        if [[ $(which tfenv) ]] ; then
            echo
            echo "[+] tfenv is already installed, listing installed version/s .." 2>/dev/null
            $(which tfenv) list 
        fi 
        tf_env_tfv=$(echo $tf_version | sed -e s/\'//g)
        echo
        echo "[+] using tfenv to install terraform v${tf_env_tfv} .."
        echo
        $(which tfenv) install $tf_env_tfv 2>/dev/null
    else
        $(which ffenv) install latest 2>/dev/null
    fi
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
    echo
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
install_python3() {
    echo
    echo "[+] installing python3 .."
    ${APT} install -y python3

    return 0
}
################
install_python2_7() {
    echo
    echo "[+] installing python2.7 .."
    ${APT} install python2.7

    return 0
}
#################
install_tmux() {
    echo 
    echo "[+] installing tmux .."
    ${APT} instal -y install install tmux

    return 0
}
#################
install_docker() {
    echo
    echo "[+] installing docker .."
    if [[ ! $(which docker ) ]] ; then
        ${SNAP} install docker
        echo
        echo "[+] enabling and starting Docker via systemctl .."
        echo
    else 
        echo
        echo "[+] docker already installed."
    fi

    return 0
}
################
install_docker-compose() {
    echo "[+] installing docker-compose .."
    ${APT} install -y docker-compose

    return 0
}
################
install_virtualenvwrapper() {
    echo "[+] installing virtualenvwrapper ..."
    $(which pip3) install virtualenvwrapper

    return 0
}
################

install_utils
install_sys_utils() {
    for util in ${utils_array[*]}; do
        if [[ "$util" == *tfenv* ]] ; then
            install_tfenv
        elif [[ "$util" == *vscode* ]] ; then 
            install_vscode
        elif [[ "$util" == *awscli* ]] ; then
            install_awscli
        elif [[ "$util" == *docker ]] ; then 
            install_docker
        elif [[ "$util" == *docker-compose* ]]; then 
            install_docker-compose 
        elif [[ "$util" == *ansible ]]; then
            install_ansible
        elif [[ "$util" == *portainer* ]]; then
            install_portainer
        elif [[ "$util" == *htop* ]]; then
            install_htop
        elif [[ "$util" == *virtualbo* ]]; then
             install_virtualbox
        elif [[ "$util" == *virtualenvwrapper* ]]; then
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




