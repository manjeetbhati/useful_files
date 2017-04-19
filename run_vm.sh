# Add Neutron security groups for ping and ssh

neutron security-group-rule-create   \
        --protocol icmp              \
        --direction ingress          \
        --remote-ip-prefix 0.0.0.0/0 \
        92942417-0fa9-4344-8c7e-8ef73a812646

neutron security-group-rule-create   \
        --protocol tcp               \
        --port-range-min 22          \
        --port-range-max 22          \
        --direction ingress          \
        --remote-ip-prefix 0.0.0.0/0 \
        92942417-0fa9-4344-8c7e-8ef73a812646

nova boot --flavor m1.tiny --image cirros-0.3.5-x86_64-disk --nic net-id=`neutron net-list | grep private | awk '{print $2}'` --max-count 1 test

neutron floatingip-create public

#nova floating-ip-associate test

