#!/bin/bash

# This perf collection script designed for OVS-DPDK enviroment. 
# Hence to get an correct information the script need to execute locally on the host which has openvswitch with dpdk configuration.

host=$(hostname | cut -d "." -f 1)
dir="/var/lib/$host-OvsPerfLog"
rm -rf $dir
mkdir -p $dir

file=$dir/cmd_output.log
>file

period="20";

run_cmd() {
  echo -e "# $1" | tee -a $file
  eval "$1" | tee -a $file
  if [[ $? -eq 0 ]]; then
        echo -e "........ Perf captured task completed..." | tee -a $file
  else
        echo -e "........ Perf task failed" | tee -a $file
        exit 1;
  fi
  sleep 2;
}

flame_graph() {
	echo -e "\nExecuting Flamegraph task"
	
	flamegraph="/tmp/FlameGraph"
    	flamegraphgit="https://github.com/brendangregg/FlameGraph.git"

    	git clone $flamegraphgit $flamegraph &> /dev/null;

    	pushd $flamegraph
        	perf script -i $dir/ovs-pmd-perf.data >& /tmp/ovs-pmd-perf.perf
        	perl stackcollapse-perf.pl  /tmp/ovs-pmd-perf.perf > /tmp/ovs-pmd-perf.folded
        	perl flamegraph.pl /tmp/ovs-pmd-perf.folded > $dir/ovs-pmd-perf.svg
    	popd

	echo -e "\nFlameGraph Output: $dir/ovs-pmd-perf.svg"
    	rm -rf $flamegraph
}

perf_scripts() {
	echo -e "\nExecuting PerfScript task"

    	perfgitscript="https://github.com/chaudron/perf_scripts.git"
    	perfscript="/tmp/perf_scripts"

    	git clone $perfgitscript $perfscript &> /dev/null;

    	pushd $perfscript
        	perf script -s $perfscript/analyze_perf_pmd_syscall.py -i $dir/ovs-syscall-pmd-perf.data /usr/sbin/ovs-vswitchd &> /dev/null >& $dir/ovs-syscall-pmd-perf.log
    	popd

	echo -e "\nPerf Script Analysis Output: $dir/ovs-syscall-pmd-perf.log"
    	rm -rf $perfscript
}

perf_collect() {

	OVS_PMD_THREADS=$(ps -To tid,comm `pidof ovs-vswitchd` | grep pmd | awk '{$1=$1};1' | cut -d " " -f 1 | xargs | sed -e 's/ /,/g')
	OVS_HANDLER_THREADS=$(ps -To tid,comm `pidof ovs-vswitchd` | grep handler | awk '{$1=$1};1' | cut -d " " -f 1 | xargs | sed -e 's/ /,/g')
	OVS_REVALIDATOR_THREADS=$(ps -To tid,comm `pidof ovs-vswitchd` | grep revalidator | awk '{$1=$1};1' | cut -d " " -f 1 | xargs | sed -e 's/ /,/g')
	OVS_VSWITCHD_THREADS=$(ps -To tid,comm `pidof ovs-vswitchd` | grep ovs-vswitchd | awk '{$1=$1};1' | cut -d " " -f 1 | xargs | sed -e 's/ /,/g')


    	run_cmd "perf record -e raw_syscalls:sys_enter  -e raw_syscalls:sys_exit -s --call-graph dwarf --per-thread -g -i -o $dir/ovs-syscall-pmd-perf.data -t $OVS_PMD_THREADS -- sleep $period";
    	run_cmd "perf record -p $OVS_PMD_THREADS -g -i -o $dir/ovs-pmd-perf.data -- sleep $period";
    	run_cmd "perf record -s --call-graph dwarf --per-thread -g -i -o $dir/ovs-handler-perf.data -t $OVS_HANDLER_THREADS -- sleep $period";
    	run_cmd "perf record -s --call-graph dwarf --per-thread -g -i -o $dir/ovs-revalidator-perf.data -t $OVS_REVALIDATOR_THREADS -- sleep $period";
    	run_cmd "perf record -s --call-graph dwarf --per-thread -g -i -o $dir/ovs-vswitchd-perf.data -t $OVS_VSWITCHD_THREADS -- sleep $period";

	echo -e "\nOVS PMD Threads Cycles and Instructions:" | tee -a $file
	perf stat -p $OVS_PMD_THREADS -e cycles:u,instructions:u -g sleep $period >> $file 2>&1 

	echo -e "\nOVS Handler Threads Cycles and Instructions:" | tee -a $file
	perf stat -p $OVS_HANDLER_THREADS -e cycles:u,instructions:u -g sleep $period >> $file 2>&1

	echo -e "\nOVS Revalidator Threads Cycles and Instructions:" | tee -a $file
	perf stat -p $OVS_REVALIDATOR_THREADS -e cycles:u,instructions:u -g sleep $period >> $file 2>&1

	echo -e "\nOVS vSwitchd Thread Cycles and Instructions:" | tee -a $file
	perf stat -p $OVS_VSWITCHD_THREADS -e cycles:u,instructions:u -g sleep $period >> $file 2>&1

    	perf_scripts;
    	flame_graph;
}

perf_collect;

archive_name="`hostname`_`date '+%F_%H%m%S'`_OVS_Perf_details.tar.gz";
tar -czf $archive_name ${dir};
echo "\nArchived all data in archive ${archive_name}";

