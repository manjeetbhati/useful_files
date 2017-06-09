# Add Neutron security groups for ping and ssh

neutron security-group-rule-create   \
        --protocol icmp              \
        --direction ingress          \
        --remote-ip-prefix 0.0.0.0/0 \
	3f682690-2704-4f3b-8e92-5f48e4f6da42

neutron security-group-rule-create   \
        --protocol tcp               \
        --port-range-min 22          \
        --port-range-max 22          \
        --direction ingress          \
        --remote-ip-prefix 0.0.0.0/0 \
	3f682690-2704-4f3b-8e92-5f48e4f6da42

nova boot --flavor m1.tiny --image cirros-0.3.5-x86_64-disk --nic net-id=`neutron net-list | grep private | awk '{print $2}'` --max-count 1 test

neutron floatingip-create public

#nova floating-ip-associate test

