set -xe
SP=`openstack network flavor profile create --driver networking_odl.l3.l3_flavor.ODLL3ServiceProvider | grep "| id" | awk '{print $4}'`

openstack network flavor create --service-type L3_ROUTER_NAT nodl

openstack network flavor add profile nodl $SP
