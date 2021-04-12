# nfv_on_stack
Automate NFV workload in OpenStack


# Description:
`nfv_on_stack` project aims to configure to automate below tasks for NFV activities.

1. Upgrade the OS packages and installed fast-datapath packages
2. Tune Grub Kernel boo parameters and enabled tuned profiles.
3. Configure Trafficgen host with pbench bunddle wrapper.
4. Created traffic profile based on the provided backend support. Support backend: trex-txrx and trex-txrx-profile
5. Created custom profile during the task execution.

# Supported Enviroment
* OS Release: RHEL8.x
* OSP Support: 16.1 and 16.2
* Trafficgen Platform support: Virtual and Baremetal
* DPDK Forwarder (TestPMD): Virtual

*Note*:- For Baremetal node it required to set password less SSH root authentication and for VM credential it is required to share by ansible enviroment variables.

# Usage:
1. Update the `hosts` inventory file with appropiate host IP or FQDN.
2. Do a basic ping test to ensure the rechability:
```
ansible -v -i hosts all -m ping
```
3. Execute the main task:
```
ansible-playbook -v -i hosts main.yml
```
