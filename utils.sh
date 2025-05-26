################
install_utils() {
    echo '############### adding sys utils ###############'
    while read UTIL; do 
        if echo $UTIL | grep -q "#"; then
            continue
        fi 
        util="$(echo $UTIL | $AWK -F"=" '{print $1}')"
        val="$(echo $UTIL | $AWK -F"=" '{print $2}')"
        if [[ "$val" -eq "1" ]]; then
                sleep 1 && echo "[~] adding $util to sys utils array .." && utils_array+=($util)
        fi
    done < $cfg_file

    # echo "[+] debugging array: $(echo ${utils_array[*]})"
    # exit 0
}
################
install_virtualenvwrapper() {
    echo
    echo "[+] installing virtualenvwrapper .."
    echo
    if [[ ! $(which pip3) ]] ; then
        echo "[+] pip3 not installed?" && install_python3
    fi
    $(which pip3) install virtualenvwrapper

    return 0
}
################
install_golang() {
    echo
    echo "[+] installing golang .."

    ${SNAP} install go --classic
    
    return 0
}
################
install_nginx() {
    echo
    echo "[+] installing golan nginx .."

    ${APT} install -y nginx
    
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
    echo
    ${APT} install -y htop

    return 0
}
################
install_ngrep() {
    echo
    ${APT} install -y ngrep

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
    ${APT} install -y python3 python3-pip

    return 0
}
################
install_python2_7() {
    echo
    echo "[+] installing python2.7 .."
    echo
    ${APT} install -y python2.7

    return 0
}
#################
install_tcpdump() {
    echo
    echo "[+] installing tcpdump .."
    echo
    ${APT} install -y tcpdump

    return 0
}
#################
install_tmux() {
    echo 
    echo "[+] installing tmux .."
    echo
    ${APT} instal -y install tmux

    return 0
}
################
install_jq() {
    echo 
    echo "[+] installing jq .."
    echo
    ${APT} install -y jq

    return 0
}
################
install_yq() {
    echo 
    echo "[+] installing yq .."
    echo
    ${SNAP} install yq --channel=v3/stable

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
	    elif [[ "$util" == *nginx* ]]; then
	        install_nginx
	    elif [[ "$util" == *python_2_7* ]]; then
	        install_python2_7
	    elif [[ "$util" == *fail2ban* ]]; then
	        install_fail2ban
	    elif [[ "$util" == *tcpdump* ]]; then
	        install_tcpdump
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
        elif [[ "$util" == *jq* ]]; then
            install_jq
        elif [[ "$util" == *yq* ]]; then
            install_yq
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





