#!/bin/bash

TEMPLATE_MACHINE_INVENTORY="inventory/dpdk-inv"
PB="dpdk.yml"

ansible-playbook -i $TEMPLATE_MACHINE_INVENTORY $PB

