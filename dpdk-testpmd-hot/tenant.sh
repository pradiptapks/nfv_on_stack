#!/bin/bash

file=/tmp/osp-env-create.txt
>$file

echofun() {
  echo -e "\n\n$1" | tee -a $file
}

run_cmd() {
  source /home/stack/overcloudrc ;
  echofun "[stack@`hostname`~]$ $1 "
  eval "$1" | tee -a $file
  if [[ $? -eq 0 ]]; then
        echo -e "\n........ TASK COMPLETED" | tee -a $file
  else
        echo -e "\n........ TASK NOT COMPLETED" | tee -a $file
        exit 1;
  fi
  sleep 2;
}

delete_nw() {
  	source /home/stack/overcloudrc ;

        for i in `openstack network list -c ID -f value`;
                do run_cmd "openstack network delete $i"; done
                run_cmd "openstack network list";

	for i in `openstack security group list -c ID -f value`;
		do run_cmd "openstack security group delete $i"; done
		run_cmd "openstack security group list";

	run_cmd "ls -l /home/stack/*.pem";
	run_cmd "rm -rf /home/stack/*.pem";
}


nw_mgmt () {	
	run_cmd "openstack network create --share --mtu 1500 --provider-physical-network management --provider-network-type flat management";
	run_cmd "openstack subnet create --network management --subnet-range 192.168.0.0/24 --gateway 192.168.0.254 --dns-nameserver 10.19.42.41 --dns-nameserver 10.11.5.19 --dns-nameserver 10.5.30.160 management-subnet";
	}	

nw_provider () {
	run_cmd "openstack network create --share --provider-physical-network provider1 --provider-network-type vlan --provider-segment 177 provider-1";
	run_cmd "openstack subnet create --no-dhcp --network provider-1 --gateway 192.168.178.1 --subnet-range 192.168.177.0/24 provider-subnet-1";

	run_cmd "openstack network create --share --provider-physical-network provider1 --provider-network-type vlan --provider-segment 178 provider-2";
	run_cmd "openstack subnet create --no-dhcp --network provider-2 --gateway 192.168.177.1 --subnet-range 192.168.178.0/24 provider-subnet-2";
}

nw_sec () {
	run_cmd "openstack security group create secgroup1";
	run_cmd "openstack security group rule create secgroup1 --protocol icmp --ingress";
	run_cmd "openstack security group rule create secgroup1 --protocol icmp --egress";
	run_cmd "openstack security group rule create secgroup1 --protocol tcp --ingress";
	run_cmd "openstack security group rule create secgroup1 --protocol udp --ingress";
	run_cmd "openstack security group rule create secgroup1 --protocol tcp --egress";
	run_cmd "openstack security group rule create secgroup1 --protocol udp --egress";
	}

quota () {
	run_cmd "openstack quota set --cores 50 --ram 200000 admin";
}



network () {
	nw_mgmt;
	nw_provider;
	nw_sec;
}

option=$1;
eval "$1";

