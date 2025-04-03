################
install_devps_utils() {
    echo '############### adding devops utils ###############'
    while read DEVOPS_UTIL; do 
        if echo $DEVOPS_UTIL | grep -q "#"; then
            continue
        fi
        util="$(echo $DEVOPS_UTIL | $AWK -F"=" '{print $1}')"
        val="$(echo $DEVOPS_UTIL | $AWK -F"=" '{print $2}')"
        if [[ "$util" == "enable_devops_utils" ]]; then
            if [ "$val" -ne "1" ]; then
                echo
                echo "[+] you decided not to enable devops utils being installed. Exiting."
                echo
                return 1
            fi
            continue
        fi
        if [[ "$util" == "terraform-version" ]] ; then
            export tf_version=$(echo $val | sed -e 's/"//g')
            result=$(awk -vn1="$val" -vn2="$tf_version" 'BEGIN{print (n1==n2)?1:0 }')
            [ "$result" == 1 ] && export ft_ver="true"
            echo "[+] Terraform version chosen: $tf_version"
            echo "[+] debugging tf_version: $val"
            val="$result"
        fi
        if [[ "$val" -eq "1" ]] || [ -n "$tf_ver" ] ; then 
            if [[ "$util" != "terraform-version" ]] || [[ "$util" != "tfenv" ]]; then
                sleep 1 && echo "[~] adding $util to devops utils array .." && devops_utils_array+=($util)
            fi
        fi
    done < $devops_cfg_file

    return 0
}
################
install_awscli() {
    if [[ ! $(which docker ) ]] ; then
        $(which pip) install awscli
    else 
        echo "[+] awscli already installed."
        echo
    fi  

    return 0
}
################
install_nodejs() {
    echo "[+] installing nodejs and npm .."
    echo
    ${APT} -y install nodejs
    if [[ ! $(which npm) ]] ; then
        ${APT} -y install npm
    fi

    return 0 
}
################
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
install_kind() {
    echo
    echo "[+] installing kind .."
    if [[ ! $(which kind) ]] ; then
        [ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.27.0/kind-linux-amd64
	chmod +x ./kind
	mv ./kind /usr/local/bin/kind
    else
        echo "[+] kind already installed."
        echo
    fi

    return 0
}
#################
install_localstack() {
    echo
    echo "[+] installing localstack .."
    if [[ ! $(which localstack) ]] ; then
        sudo su -u $LOCALSTACK_USER -c 'python3 -m pip install localstack'
    else
        echo "[+] localstack already installed."
        echo
    fi

    return 0
}
#################
install_tfenv() {
    echo 
    echo "[+] installing tfenv .."
    mkdir -p /usr/local/bin 2>&1
    rm -rf /home/${SUDO_USER}/.tfenv
    git clone https://github.com/tfutils/tfenv.git /home/${SUDO_USER}/.tfenv &>/dev/null || exit 125
    ln -s /home/${SUDO_USER}/.tfenv/bin/* /usr/local/bin 2>/dev/null
    ln -s /home/${SUDO_USER}/.tfenv/bin/* /bin 2>/dev/null
    chown -R ${SUDO_USER} /home/${SUDO_USER}/.tfenv/bin/
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

install_devps_utils
install_devops_utils() {
    for util in ${devops_utils_array[*]}; do
        if [[ "$util" == *awscli* ]] ; then
            install_awscli
        elif [[ "$util" == *tfenv* ]] ; then
            install_tfenv
        elif [[ "$util" == *nodejs* ]] ; then
            install_nodejs
        elif [[ "$util" == *localstack* ]] ; then
            install_localstack
        elif [[ "$util" == *kind* ]] ; then
            install_kind
        elif [[ "$util" == *docker* ]] ; then
            install_docker
        elif [[ "$util" == *docker-compose* ]] ; then
            install_docker-compose
        elif [[ "$util" == *portainer* ]]; then
            install_portainer
        else 
            echo 
            echo "[+] installing ${util} .."
            ${APT} -y install ${util} 2>> error.log
        fi

    done
    echo

    return 0
}

