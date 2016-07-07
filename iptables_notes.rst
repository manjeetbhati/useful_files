IP TABLES NOTES
===============

Iptables are three chains INPUT (rules for incoming trafic),
OUTPUT and FORWARD.

Check what are enabled or being used

sudo iptables -L -v

Check what policy chains are configured to do with unmatched traffic

sudo iptables -L

To append rules to existing chain

sudo iptables -A INPUT -s 10.10.10.10 -j DROP


To block a port for specific ip

iptables -A INPUT -p tcp --dport ssh -s 10.10.10.10 -j DROP



