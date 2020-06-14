################
svc_mngr() {
    echo "[+] starting serVice mngr .."
    SYSCTL=$(which systemctl)
    $(which systemctl) daemon-reload
    for svc in ${services_array[*]}; do 
        ${SYSCTL} restart $svc
        ${SYSCTL} enable $svc
    done 
    
    return $?
}
################