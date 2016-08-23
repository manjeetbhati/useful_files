#!/bin/bash 
COUNTER=0
NETCOUNT=0
BINDCOUNT=0
KBPS=100

source /opt/stack/devstack/openrc admin admin

while [  $NETCOUNT -lt 20 ]; do
    time neutron net-create testnetwork-$NETCOUNT
    let NETCOUNT=NETCOUNT+1
    done

 while [  $COUNTER -lt 20 ]; do
    time neutron qos-policy-create testpolicy-$COUNTER
    time neutron qos-bandwidth-limit-rule-create --max-kbps $KBPS testpolicy-$COUNTER
       let COUNTER=COUNTER+1
       let KBPS=KBPS+20
         done

 while [  $BINDCOUNT -lt 20 ]; do
     time neutron net-update --qos-policy testpolicy-$BINDCOUNT testnetwork-$BINDCOUNT
      let BINDCOUNT=BINDCOUNT+1
        done
