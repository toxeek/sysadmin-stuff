#!/bin/bash

for m in $(find . -name "*.sh"); do
    chmod +x $m
    ./$m
done

./addtoSudo.sh
./setPath.sh

for m in ./ansible/playbooks/*yml; do
    $(which ansible-playbook) $m
done


