# nfv_on_stack
Automate NFV workload in OpenStack


Description:
nfv_on_stack project aims to configure testpmd and pbench with trafficgen configuration 
The roadmap is to automate the provision process of testpmd and automate the binary-search teast with user-defined packet loss scenario.

nfv_on_stack
___ nfv_on_stack/ansible.cfg
___ nfv_on_stack/boot-strap.yml
___ nfv_on_stack/group_vars
___ ___ nfv_on_stack/group_vars/all.yml
___ nfv_on_stack/grub.yml
___ nfv_on_stack/hosts
___ nfv_on_stack/main.yml
___ nfv_on_stack/README.md
___ nfv_on_stack/ssh_root.yml
___ nfv_on_stack/trafficgen-config.yml
___ nfv_on_stack/tuned.yml
___ nfv_on_stack/workload-config.yml


Note: Currently the test has executed on RHOSP16.x platform where both trafficgen and testpmd running as VM.

