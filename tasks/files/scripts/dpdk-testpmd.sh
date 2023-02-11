modprobe vfio
modprobe vfio-pci

ip link set dev eth1 down
ip link set dev eth2 down

dpdk-devbind.py --bind=vfio-pci 0000:00:04.0
dpdk-devbind.py --bind=vfio-pci 0000:00:05.0


tail -f /dev/null | dpdk-testpmd -l 3,4,5 -n 4 --huge-dir=/dev/hugepages \
        -a 0000:00:04.0 -a 0000:00:05.0 \
        --socket-mem 2048 \
        -- --nb-cores=2 --forward-mode=io \
        --rxd=1024 --txd=1024 --rxq=1 --txq=1 \
        --burst=64 --mbcache=512 -a --rss-udp \
        --max-pkt-len=9000 \
        --record-core-cycles \
        --record-burst-stats --stats-period 5 >/tmp/dpdk-testpmd.log 2>&1 &
