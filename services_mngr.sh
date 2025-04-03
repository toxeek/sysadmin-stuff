################
utils_svc_mngr() {
    echo "[+] starting serVice mngr .."
    SYSCTL=$(which systemctl)
    echo "[+] doing a daemon-reload .."
    $SYSCTL daemon-reload
    for svc in ${services_array[*]}; do 
        if ${SYSCTL} list-units --type service | grep -q $svc; then
            echo 
            echo "[+] retarting, and enabling $svc .."
            ${SYSCTL} daemon-reload
            ${SYSCTL} restart $svc
            ${SYSCTL} enable $svc
        fi
    done 
    
    return $?
}
################
