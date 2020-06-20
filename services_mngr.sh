################
utils_svc_mngr() {
    echo "[+] starting serVice mngr .."
    SYSCTL=$(which systemctl)
    $(which systemctl) daemon-reload
    for svc in ${services_array[*]}; do 
        if ${SYSCTL} list-units --type service | grep -q $svc; then
            ${SYSCTL} restart $svc
            ${SYSCTL} enable $svc
        fi
    done 
    
    return $?
}
################