# Add Neutron security groups for ping and ssh

nova boot --flavor m1.tiny --image cirros-0.3.5-x86_64-disk --nic net-id=`neutron net-list | grep private | awk '{print $2}'` --max-count 1 test

SG=`nova list-secgroup  test | grep default | awk '{print $2}'`

neutron security-group-rule-create   \
        --protocol icmp              \
        --direction ingress          \
        --remote-ip-prefix 0.0.0.0/0 \
	    $SG

neutron security-group-rule-create   \
        --protocol tcp               \
        --port-range-min 22          \
        --port-range-max 22          \
        --direction ingress          \
        --remote-ip-prefix 0.0.0.0/0 \
        $SG

FIP=`neutron floatingip-create public | grep "floating_ip_address" | awk '{print $4}'`

openstack server add floating ip test $FIP

