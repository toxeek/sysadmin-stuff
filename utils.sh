################
install_utils() {
    echo '############### adding sys utils ###############'
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
install_golang() {
    echo
    echo "[+] installing golan 1.17 .."

    snap install go --classic
    
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
install_ansible() {
    echo "[+] installing ansible .."
    echo
    ${APT} install -y ansible

    return 0
}
################
install_monit() {
    echo "´[+] installing monit .."
    echo
    ${APT} install -y monit

    return 0
}
################
install_fail2ban() {
    echo "´[+] installing fail2ban .."
    echo
    ${APT} install -y fail2ban

    return 0
}
################
install_htop() {
    if [[ $(which htop) ]]; then
        echo
        echo "[+] htop already installed, passing." && return 1
    else
        echo
        ${APT} install -y htop
    fi

    return 0
}
################
install_ngrep() {
    if [[ $(which ngrep) ]]; then
        echo
        echo "[+] ngrep already installed, passing." && return 1
    else
        echo
        ${APT} install -y ngrep
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
install_vscode() {
    echo
    echo "[+] installing Visual Code Studio .."
    echo
    ${SNAP} install --classic code

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
    mkdir -p /usr/local/etckeeper/run
    echo
    echo "[+] installing etckeeper .."
    ${APT} install -y etckeeper &>/dev/null
    echo
    if [[ ! $(which etckeeper) ]] ; then
        echo "[+] doing etckeeper init in /etc .."
        cd /etc && $(which etckeeper) init && touch /usr/local/etckeeper/run/etckeeper.lock
    else
        $(which etckeeper) commit "commi of /etc"
    fi
    cd ${CWD}

    return 0
}
#################
install_whois() {
    echo
    echo "[+] installing whois .."
    ${APT} install -y whois

    return 0
}
##################
# redundant, as you will need to clone this repository somehow
install_git() {
    echo
    echo "[+] installing git .."
    if [[ $(which git) ]]; then
        echo "[+] git already installed .."
    else
        ${APT} -y install git
    fi 
    if $(which git) config --list | grep -q "user.name"; then
        echo "[+] git already configured .."
    else 
        echo "[+] enter you email address for git use:"
        read email
        echo "[+] enter your user name for git to use:"
        read user
        $(which git) config --global user.email "${email}"
        $(which git) config --global user.name "${user}"
    fi

    # needed for metasploit git clone
    git config http.sslVerify false
    git config --global http.postBuffer 1048576000


    return 0
}
##################
install_mariadb_10_5() {
    if [[ $(which mariadb) ]]; then
        echo "[+] mariadb already installed .. passsing."
        return 0
    fi
    echo
    echo "[+] installing mariadb 10.5 with defaults . you will be prompted."
    echo "[+] addding apt-get key .."
    ${WGET} -qO - 'https://mariadb.org/mariadb_release_signing_key.asc' | apt-key add -
    echo "[+] adding mariadb repository .."
    $(which add-apt-repository) 'deb [arch=amd64] http://mariadb.mirror.globo.tech/repo/10.5/ubuntu focal main'
    echo "[+] updating apt-get .."
    ${APT} update
    ${APT} install -y mariadb-server mariadb-client
    echo "[+] starting mysql_secure_installation .."
    if [ ! -r "/usr/local/src/.mysql_sec_inst.lock" ]; then 
        $(which mysql_secure_installation) && touch "/usr/local/src/.mysql_sec_inst.lock"
    fi

    echo
    echo "[+] mariadb installed." && sleep 1

    return 0
}
##################

install_utils
install_sys_utils() {
    for util in ${utils_array[*]}; do
        if [[ "$util" == *vscode* ]] ; then 
            install_vscode
        elif [[ "$util" == *ansible ]]; then
            install_ansible
        elif [[ "$util" == *htop* ]]; then
            install_htop
	    elif [[ "$util" == *monit* ]]; then
	        install_monit
	    elif [[ "$util" == *fail2ban* ]]; then
	        install_fail2ban
        elif [[ "$util" == *virtualbox* ]]; then
             install_virtualbox
        elif [[ "$util" == *etckeeper* ]]; then
             install_etckeeper
        elif [[ "$util" == *golang* ]]; then
             install_golang
        elif [[ "$util" == *whois* ]]; then
             install_whois
        elif [[ "$util" == *ngrep* ]]; then
             install_ngrep
        elif [[ "$util" == *virtualenvwrapper* ]]; then
            install_virtualenvwrapper
        elif [[ "$util" == "git" ]]; then
            install_git
        elif [[ "$util" == *mariadb_10_5* ]]; then
            install_mariadb_10_5
        else 
            echo 
            echo "[+] installing ${util} .."
            ${APT} -y install ${util} 2>>./error.log
        fi
    done
    echo

    return 0
}
################





