# Copyright 2016 OpenStack Foundation
# All Rights Reserved.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

import netaddr
import json
from tempest import test
from tempest_lib.common.utils import data_utils

from neutron.tests.api import base
from neutron.tests.tempest import config

CONF = config.CONF

DEFAULT_IP_CONSUMED = 3


class NetworksIpAvailabilityTestJSON(base.BaseNetworkTest):

    """
    Tests the following operations in the Neutron API using the REST client for
    Neutron:

        list ip network ip availability of all networks
        show ip network ip availability of a network

    """

    @classmethod
    def resource_setup(cls):
        super(NetworksIpAvailabilityTestJSON, cls).resource_setup()

    @classmethod
    def _create_subnet(self, network, ip_version):
        """Derive last subnet CIDR block from tenant CIDR and
           create the subnet with that derived CIDR
        """
        if ip_version == 4:
            cidr = netaddr.IPNetwork(CONF.network.tenant_network_cidr)
            mask_bits = CONF.network.tenant_network_mask_bits
        elif ip_version == 6:
            cidr = netaddr.IPNetwork(CONF.network.tenant_network_v6_cidr)
            mask_bits = CONF.network.tenant_network_v6_mask_bits

        subnet_cidr = list(cidr.subnet(mask_bits))[-1]
        prefix_len = subnet_cidr.prefixlen
        gateway_ip = str(netaddr.IPAddress(subnet_cidr) + 1)
        subnet = self.create_subnet(network, gateway=gateway_ip,
                                   cidr=subnet_cidr, mask_bits=mask_bits,
                                   ip_version=ip_version)
        return subnet, prefix_len

    @classmethod
    def is_extension_loaded(self, ext_name):
        ext_status = False
        loaded_extensions = self.client.list_extensions()
        exts = loaded_extensions['extensions']
        for ext in exts:
            if ext['alias'] == ext_name:
                ext_status = True
                break
        return ext_status

    @classmethod
    def _delete_network(self, network):
        # Deleting network also deletes its subnets if exists
        self.client.delete_network(network['id'])
        if network in self.networks:
            self.networks.remove(network)
        for subnet in self.subnets:
            if subnet['network_id'] == network['id']:
                self.subnets.remove(subnet)


def calc_total_ips(prefix, ip_version):
    # will calculate total ips after removing reserved.
    if ip_version == 4:
        total_ips = (2 ** (32 - prefix)) - DEFAULT_IP_CONSUMED
    elif ip_version == 6:
        total_ips = (2 ** (128 - prefix)) - 2
    return total_ips


class NetworksIpAvailabilityIPv4TestJSON(NetworksIpAvailabilityTestJSON):

    @test.attr(type='smoke')
    @test.idempotent_id('0f33cc8c-1bf6-47d1-9ce1-010618240599')
    def test_admin_list_network_ip_availability(self):
        if not self.is_extension_loaded('network-ip-availability'):
            self.skipTest("net ip availability extension not loaded")
        net_name = data_utils.rand_name('network-')
        network = self.create_network(network_name=net_name)
        self.addCleanup(self._delete_network, network)
        body = self.client.list_network_ip_availabilities()
        availabilities = body['network_ip_availabilities']
        for availability in availabilities:
            if availability['id'] == network['id']:
                # for a network without subnet total and used ips will be 0
                self.assertEqual(availability['total_ips'], 0)
                self.assertEqual(availability['used_ips'], 0)

    @test.attr(type='smoke')
    @test.idempotent_id('3aecd3b2-16ed-4b87-a54a-91d7b3c2986b')
    def test_admin_list_network_ip_availability_after_subnet(self):
        if not self.is_extension_loaded('network-ip-availability'):
            self.skipTest("net ip availability extension not loaded")
        net_name = data_utils.rand_name('network-')
        network = self.create_network(network_name=net_name)
        self.addCleanup(self._delete_network, network)
        subnet, prefix = self._create_subnet(network, 4)
        port1 = self.client.create_port(network_id=network['id'])
        self.addCleanup(self.client.delete_port, port1['port']['id'])
        port2 = self.client.create_port(network_id=network['id'])
        self.addCleanup(self.client.delete_port, port2['port']['id'])
        port3 = self.client.create_port(network_id=network['id'])
        self.addCleanup(self.client.delete_port, port3['port']['id'])
        body = self.client.list_network_ip_availabilities()
        availabilities = body['network_ip_availabilities']
        for availability in availabilities:
            if availability['id'] == network['id']:
                with open('test.txt', 'wb') as handle:
                    json.dump(availability, handle)
                self.assertEqual(availability['total_ips'],
                                 calc_total_ips(prefix, 4))


class NetworksIpAvailabilityIPv6TestJSON(NetworksIpAvailabilityTestJSON):

    @test.attr(type='smoke')
    @test.idempotent_id('33b78891-6fbb-4a51-9cf7-3fb782fb3c4d')
    def test_admin_list_network_ipv6_availability_after_subnet(self):
        if not self.is_extension_loaded('network-ip-availability'):
            self.skipTest("net ip availability extension not loaded")
        net_name = data_utils.rand_name('network-')
        network = self.create_network(network_name=net_name)
        self.addCleanup(self._delete_network, network)
        subnet, prefix = self._create_subnet(network, 6)
        body = self.client.list_network_ip_availabilities()
        availabilities = body['network_ip_availabilities']
        for availability in availabilities:
            if availability['id'] == network['id']:
                self.assertEqual(availability['total_ips'],
                                 calc_total_ips(prefix, 6))
