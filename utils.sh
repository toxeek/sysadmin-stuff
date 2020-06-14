################
install_utils() {
    echo '############### installing sys utils ###############'
    while read UTIL; do 
        if echo $UTIL | grep -q "#"; then
            continue
        fi 
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
                sleep 1 && echo "[~] adding $util to sys utils array .." && utils_array+=($util)
            fi
        fi
    done < $cfg_file

    # echo "[+] debugging array: $(echo ${utils_array[*]})"
}
################
install_vritualenvwrapper() {
    echo
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
    echo "[+] installing awscli .."
    echo
    $(which pip3) install awscli
}
################
install_ansible() {
    echo "[+] installing ansible .."
    echo
    ${APT} install -y ansible

    return 0
}
################
install_htop() {
    if [[ $(which htop) ]]; then
        echo
        echo "[+] htop already installed, passing." && return 1
    else
        echo
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
    echo
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
    if [[ ! $(which tfenv) ]] ; then
        echo "[+] tfenv installation problems. exiting" && exit 125
    fi

    if [[ $(which tfenv) ]] ; then
        echo
        echo "[+] tfenv is already installed, listing installed version/s .." 2>/dev/null
        $(which tfenv) list 
    fi

    if [ ! -z "$tf_version" ]; then 
        tf_env_tfv=$(echo $tf_version | sed -e s/\'//g)
        echo
        echo "[+] using tfenv to install terraform v${tf_env_tfv} .."
        echo
        $(which tfenv) install $tf_env_tfv 2>/dev/null
        echo "[+] switching to terraform v${tf_env_tfv} .."
        $(which tfenv) use ${tf_env_tfv} 2>/dev/null
    else
        $(which tfenv) install latest 2>/dev/null
        echo
        echo "[+] switching to latest terraform version ..."
        $(which tfenv) use latest 2>/dev/null
        $(which tfenv) list 2>/dev/null
    fi

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
    $(which pip3) uninstall -y awscli &>/dev/null
    $(which pip3) install awscli 

    return 0
}
################
install_python3() {
    echo
    echo "[+] installing python3 .."
    echo
    ${APT} install -y python3

    return 0
}
################
install_python2_7() {
    echo
    echo "[+] installing python2.7 .."
    echo
    ${APT} install python2.7

    return 0
}
#################
install_tmux() {
    echo 
    echo "[+] installing tmux .."
    echo
    ${APT} instal -y install install tmux

    return 0
}
#################
install_docker() {
    echo
    echo "[+] installing docker .."
    if [[ ! $(which docker ) ]] ; then
        ${SNAP} install docker
    else 
        echo "[+] docker already installed."
        echo
    fi

    return 0
}
################
install_docker-compose() {
    echo "[+] installing docker-compose .."
    ${APT} install -y docker-compose

    return 0
}
#################
install_microk8s() {
    echo
    echo "[+] installing microk8s via snap .."
    if [[ ! $(which microk8s ) ]] ; then
        ${SNAP} install microk8s --classic
    else
        echo "[+] microk8s already installed."
        echo
    fi

    return 0
}
################
install_virtualenvwrapper() {
    echo
    echo "[+] installing virtualenvwrapper ..."
    $(which pip3) install virtualenvwrapper

    return 0
}
################
install_etckeeper() {
    [[ ! $(which git ) ]] && echo "[+] etckeeper uses git, exiting" && return 1
    CWD="$(pwd)"
    mkdir -p /var/run/etckeeper
    echo
    echo "[+] installing etckeeper .."
    ${APT} install -y etckeeper &>/dev/null
    echo
    if [ ! -r "/var/run/etckeeper/etckeeper.lock" ] ; then
        echo "[+] doing etckeeper init in /etc .."
        cd /etc && $(which etckeeper) init && touch /var/run/etckeeper/etckeeper.lock
    fi

    $(which etckeeper) commit "commi of /etc"
    cd ${CWD}

    return 0
}
#################
install_whois() {
    echo "[+] installing whois .."
    ${APT} install -y whois

    return 0
}
##################
install_git() {
    echo
    echo "[+] installing git .."
    ${APT} -y install git 
    echo "[+] enter you email address for git use:"
    read email
    echo "[+] enter your user name for git to use:"
    read user

    $(which git) config --global user.email "${email}"
    $(which git) config --global user.name "${user}"

    return 0
}
##################

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
        elif [[ "$util" == *virtualbox* ]]; then
             install_virtualbox
        elif [[ "$util" == *microk8s* ]]; then
             install_microk8s
        elif [[ "$util" == *etckeeper* ]]; then
             install_etckeeper
        elif [[ "$util" == *whois* ]]; then
             install_whois
        elif [[ "$util" == *virtualenvwrapper* ]]; then
            install_virtualenvwrapper
        elif [[ "$util" == "git" ]]; then
            install_git
        else 
            echo 
            echo "[+] installing ${util} .."
            ${APT} -y install ${util}
        fi
    done
    echo
    echo '############### sys utils installed ###############'
    echo

    return 0
}
################





