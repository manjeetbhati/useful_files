#!/bin/bash 
COUNTER=0


while [  $COUNTER -lt 20 ]; do
    time neutron port-create --name port-$COUNTER testnetwork-$COUNTER
    time neutron port-update --qos-policy testpolicy-$COUNTER port-$COUNTER
        let COUNTER=COUNTER+1
        done

