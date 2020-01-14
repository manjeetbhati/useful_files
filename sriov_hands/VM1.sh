sudo echo "8021q" >> /etc/modules
sudo ifconfig eth1 10.9.0.20 netmask 255.255.255.0 up
sudo vconfig add eth1 1022
sudo vconfig add eth1 1023
sudo ip link set eth1.1022 up
sudo ip link set eth1.1023 up
sudo ip link set dev eth1.1022 address fa:16:3e:73:2d:12
sudo ip link set dev eth1.1023 address fa:16:3e:54:0c:b1
sudo ifconfig eth1.1022 10.18.0.21 netmask 255.255.255.0 up
sudo ifconfig eth1.1023 10.27.0.17 netmask 255.255.255.0 up
