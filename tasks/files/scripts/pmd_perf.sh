set -ux
perf record -e raw_syscalls:sys_enter -e raw_syscalls:sys_exit \
	-s --call-graph dwarf --per-thread -g -i \
	-t `ps -To tid,comm \`pidof ovs-vswitchd\` | grep pmd | awk '{$1=$1};1' | cut -d " " -f 1 | xargs | sed -e 's/ /,/g'` \
	-- sleep 60
