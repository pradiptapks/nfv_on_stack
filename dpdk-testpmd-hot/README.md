Heat Template to create VNFs on OpenStack NFVi Cluster
======================================================
The template is designed for HWOL enviroment.

User need to modify `vnf-enviroment.yaml` file to pass the resource requirements.

1. Pass VNF requirement details the enviroment file `vnf-enviroment.yaml`:

``` 
parameters:
  root_password: 100yard-
  image_name: rhel8
  image_url: http://download.eng.pek2.redhat.com/released/RHEL-8/8.4.0/BaseOS/x86_64/images/rhel-guest-image-8.4-992.x86_64.qcow2
  vnf_disk_size: 20
  vnf_ram_size: 10240
  vnf_cpu_count: 6
  vnf_scale_limit: 12
  vnf_az: nova
  management_subnet: management-subnet
  provider_subnet1: provider-subnet-1
  provider_subnet2: provider-subnet-1
```
2. Validate the stack template with `--dry-run`.

`openstack stack create -t vnf-hwol.yaml -e vnf-enviroment.yaml $stackname --dry-run`

3. Execute the stack for resource creation

`openstack stack create -t vnf-hwol.yaml -e vnf-enviroment.yaml $stackname --wait`

4. Post deployment of stack use the script to collect the management Ips and ssh key details.
`./vnf-mgmt-port-data.sh $stackname`
