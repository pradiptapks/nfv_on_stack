source /home/stack/overcloudrc
VM_ID=$(openstack server list -c ID -f value)
for UUID in $VM_ID;
do
	echo -e "Rebooting server: $UUID";
	openstack server reboot $UUID;
done
