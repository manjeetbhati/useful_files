set -xe
#source /home/manjeets/devstack/openrc admin demo
echo "creating sriov networks, subnets, trunk port and subports"
NET="trunknet"
SUBPORTNET="subport-net"
openstack network create --provider-physical-network physnet --provider-network-type flat $NET
openstack subnet create --subnet-range "10.9.0.0/24" --network $NET --dns-nameserver 8.8.4.4 trunk-sub
openstack port create --network $NET  --vnic-type direct trunk-port

openstack network create --provider-physical-network physnet --provider-network-type vlan --provider-segment 1022 $SUBPORTNET
openstack subnet create --subnet-range "10.18.0.0/24" --network $SUBPORTNET --dns-nameserver 8.8.4.4 subport1-sub
openstack port create --network $SUBPORTNET  --vnic-type direct  subport1
 
openstack network create --provider-physical-network physnet --provider-network-type vlan --provider-segment 1023 ${SUBPORTNET}2
openstack subnet create --subnet-range "10.27.0.0/24" --network ${SUBPORTNET}2 --dns-nameserver 8.8.4.4 subport2-sub
openstack port create --network ${SUBPORTNET}2  --vnic-type direct  subport2
 
#openstack network trunk create --parent-port trunk-port trunk
#openstack network trunk set --subport port=subport1,segmentation-type=vlan,segmentation-id=1022 \
 #   --subport port=subport2,segmentation-type=vlan,segmentation-id=1023 trunk

echo "adding icmp and tcp rule to security groups"

SG1=`openstack security group list --project demo -c ID | sed -n -e '4{p;q}' | awk '{print $2}'`
SG2=`openstack security group list --project admin -c ID | sed -n -e '4{p;q}' | awk '{print $2}'`
SGS="$SG1","$SG2"

for i in $(echo $SGS | sed "s/,/ /g")
do

neutron security-group-rule-create   \
        --protocol icmp              \
        --direction ingress          \
        --remote-ip-prefix 0.0.0.0/0 \
        $i

neutron security-group-rule-create   \
        --protocol tcp               \
        --port-range-min 22          \
        --port-range-max 22          \
        --direction ingress          \
        --remote-ip-prefix 0.0.0.0/0 \
        $i
done

echo "create keypair"

openstack keypair create oskey > oskey
chmod 600 oskey
#openstack server create --flavor m1.small --image ubuntusriov --nic port-id=trunk-port trunk-server

openstack port create --network private ovsport
openstack port create --network private ovsport2

openstack port create --network subport-net  --vnic-type direct  subport12
openstack port create --network subport-net2  --vnic-type direct  subport22

openstack image create --public --disk-format raw --container-format bare --file bionici40.raw bionici40evf

echo "create two servers"

openstack server create --flavor m1.small --image  bionici40evf  --key-name oskey --nic port-id=trunk-port --nic port-id=ovsport trunk-server

openstack server create --flavor m1.small --image   bionici40evf  --key-name oskey --nic port-id=subport12 --nic port-id=subport22 --nic port-id=ovsport2 trunk-server2
FIP=`neutron floatingip-create public | grep "floating_ip_address" | awk '{print $4}'`
FIP2=`neutron floatingip-create public | grep "floating_ip_address" | awk '{print $4}'`

openstack server add floating ip trunk-server $FIP
openstack server add floating ip trunk-server2 $FIP2
# create vm on subport1 or subport2
openstack network trunk create --parent-port trunk-port trunk
openstack network trunk set --subport port=subport1,segmentation-type=vlan,segmentation-id=1022 \
    --subport port=subport2,segmentation-type=vlan,segmentation-id=1023 trunk
