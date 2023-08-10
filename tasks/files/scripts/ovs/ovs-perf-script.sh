#!/bin/bash

#set -ux

host=$(hostname -s)
dir="/var/ovs_perf_data"
rm -rf $dir
mkdir -p $dir

file=$dir/cmd_output.log
>file

echofun() {
  echo -e "\n\n$1" | tee -a $file
}

run_cmd() {
  echofun "[root@`hostname`~]$ $1 "
  eval "$1" | tee -a $file
  if [[ $? -eq 0 ]]; then
        echo -e "\n........ Perf captured task completed..." | tee -a $file
  else
        echo -e "\n........ Perf task failed" | tee -a $file
        exit 1;
  fi
  sleep 5;
}

echo -e "\nPerf Data Collection OVS PMD Threads:" | tee -a $file

run_cmd "perf record -e syscalls:sys_enter_*  -e syscalls:sys_exit_* \
	-s --call-graph dwarf --per-thread -g -i -o $dir/ovs-pmd-perf.data \
	-t `ps -To tid,comm \`pidof ovs-vswitchd\` | grep pmd | awk '{$1=$1};1' | cut -d \" \" -f 1 | xargs | sed -e 's/ /,/g'` \
	-- sleep 60";

echo -e "\nPerf Data Collection OVS Handler Threads:"| tee -a $file
run_cmd "perf record \
	-s --call-graph dwarf --per-thread -g -i -o $dir/ovs-handler-perf.data \
	-t `ps -To tid,comm \`pidof ovs-vswitchd\` | grep handler | awk '{$1=$1};1' | cut -d " " -f 1 | xargs | sed -e 's/ /,/g'` \
	-- sleep 60";

echo -e "\nPerf Data Collection OVS Revalidator Threads:"| tee -a $file
run_cmd "perf record \
	-s --call-graph dwarf --per-thread -g -i -o $dir/ovs-revalidator-perf.data \
	-t `ps -To tid,comm \`pidof ovs-vswitchd\` | grep revalidator | awk '{$1=$1};1' | cut -d " " -f 1 | xargs | sed -e 's/ /,/g'` \
	-- sleep 60";

echo -e "\nPerf Data Collection OVS Master Threads:"| tee -a $file
run_cmd "perf record \
	-s --call-graph dwarf --per-thread -g -i -o $dir/ovs-vswitchd-perf.data \
	-t `ps -To tid,comm \`pidof ovs-vswitchd\` | grep ovs-vswitchd | awk '{$1=$1};1' | cut -d " " -f 1 | xargs | sed -e 's/ /,/g'` \
	-- sleep 60";


archive_name="`hostname`_`date '+%F_%H%m%S'`_OVS_Perf_details.tar.gz";
tar -czf $archive_name ${dir};
echo "\nArchived all data in archive ${archive_name}";
