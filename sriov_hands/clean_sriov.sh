openstack server delete trunk-server trunk-server2
sleep 3
openstack network trunk delete trunk
openstack port delete subport12 subport22
openstack port delete trunk-port subport1 subport2 subport12 subport22
