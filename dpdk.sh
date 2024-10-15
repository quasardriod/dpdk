#!/bin/bash

if [ -z $1 ];then
    INVENTORY="ansible/inventory/dpdk-inv"
else
    INVENTORY=$1
    if [ ! -f $INVENTORY ];then
        printf "\nERROR: Failed to find inventory file.\n"
        exit 1
    fi
fi
PB="ansible/dpdk.yml"

ansible-playbook -i $INVENTORY $PB

