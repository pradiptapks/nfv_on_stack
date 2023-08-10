#flag="dpif_netdev lacp dpdk bond dpif_netdev hmap pmd_perf"
flag="lacp dpdk bond hmap"

for i in $flag;
do
	sudo ovs-appctl vlog/set $i:file:dbg
done

> /var/log/openvswitch/ovs-vswitchd.log

ovs-ofctl mod-port br-intlbond br-intlbond down
