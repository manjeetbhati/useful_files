set -xe
echo "creating 3 networks -----------"
sleep 2
neutron net-create net1
neutron subnet-create --name net1-subnet net1 20.20.1.0/24

echo "creating 6 ports -----------"
sleep 2
P1=`neutron port-create --name p1 net1 | sed -n '18 p' | awk '{print $4}'`
P2=`neutron port-create --name p2 net1 | sed -n '18 p' | awk '{print $4}'`
P3=`neutron port-create --name p3 net1 | sed -n '18 p' | awk '{print $4}'`
P4=`neutron port-create --name p4 net1 | sed -n '18 p' | awk '{print $4}'`
P5=`neutron port-create --name p5 net1 | sed -n '18 p' | awk '{print $4}'`
P6=`neutron port-create --name p6 net1 | sed -n '18 p' | awk '{print $4}'`

echo $P1
echo $P2
echo $P3
echo $P4
echo $P5
echo $P6

sleep 5

echo "Creating 3 instances---------------"
sleep 3
nova boot --flavor m1.nano --image cirros-0.3.5-x86_64-disk --nic port-id=$P1 --nic port-id=$P2 --max-count 1 vm1
nova boot --flavor m1.nano --image cirros-0.3.5-x86_64-disk --nic port-id=$P3 --nic port-id=$P4 --max-count 1 vm2
nova boot --flavor m1.nano --image cirros-0.3.5-x86_64-disk --nic port-id=$P5 --nic port-id=$P6 --max-count 1 vm3


echo "creating port pairs ------------"
sleep 2
neutron port-pair-create \
  --description "Firewall SF instance 1" \
  --ingress p1 \
  --egress p2 PP1

neutron port-pair-create \
  --description "Firewall SF instance 2" \
  --ingress p3 \
  --egress p4 PP2

neutron port-pair-create \
  --description "Firewall SF instance 3" \
  --ingress p5 \
  --egress p6 PP3

echo "creating port pair group -------------"
sleep 3
neutron port-pair-group-create \
  --port-pair PP1 --port-pair PP2 PPG1

neutron port-pair-group-create \
  --port-pair PP3 PPG2
