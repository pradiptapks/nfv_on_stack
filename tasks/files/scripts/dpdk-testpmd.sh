modprobe vfio
modprobe vfio-pci

ip link set dev eth0 down
ip link set dev eth1 down

PF1="0000:00:03.0"
PF2="0000:00:04.0"

dpdk-devbind.py --bind=vfio-pci $PF1 $PF2

#tail -f /dev/null | dpdk-testpmd -l 3,4,5 -n 4 --huge-dir=/dev/hugepages \
#        -a $PF1 -a $PF2 \
#        --socket-mem 2048 \
#        -- --nb-cores=2 --forward-mode=io \
#        --rxd=1024 --txd=1024 --rxq=1 --txq=1 \
#        --burst=64 --mbcache=512 -a --rss-udp \
#        --max-pkt-len=9000 \
#        --record-core-cycles \
#        --record-burst-stats --stats-period 5 >/tmp/dpdk-testpmd.log 2>&1 &
