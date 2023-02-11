stack="$1"

VNFIP="$HOME/vnf-ip.txt"
KEYFILE="$HOME/stack.key"
>$VNFIP

mgmt_port=$(openstack stack output show $stack vnf_management_port -c output_value -f json | jq [.output_value]|grep \"|cut -d '"' -f2)

for port in $mgmt_port; 
do 
	openstack port show --fit-width $port -c fixed_ips -f json|jq '.fixed_ips[].ip_address'| cut -d '"' -f 2 >> $VNFIP
done

echo -e "Management IPs of VNF: $VNFIP"; cat $VNFIP

openstack stack output show $stack private_key -c output_value -f value > $KEYFILE; chmod 0600 $KEYFILE

echo -e "Keyfile location: $KEYFILE"


