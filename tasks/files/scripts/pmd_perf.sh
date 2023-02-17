host=$(hostname -s)

set -ux
perf record -e raw_syscalls:sys_enter -e raw_syscalls:sys_exit \
	-s --call-graph dwarf --per-thread -g -i -o /tmp/$host-perf1.data \
	-t `ps -To tid,comm \`pidof ovs-vswitchd\` | grep pmd | awk '{$1=$1};1' | cut -d " " -f 1 | xargs | sed -e 's/ /,/g'` \
	-- sleep 60

sleep 10

perf record -e syscalls:sys_enter_* -s --call-graph dwarf \
	--per-thread -g -i -o /tmp/$host-perf2.data \
	-t `ps -To tid,comm \`pidof ovs-vswitchd\` | grep pmd | awk '{$1=$1};1' | cut -d " " -f 1 | xargs | sed -e 's/ /,/g'` \
	-- sleep 60

