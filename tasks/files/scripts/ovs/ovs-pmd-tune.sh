# MLXc6-VM
ovs-vsctl set Interface dpdk1 options:n_rxq=1 other_config:pmd-rxq-affinity="0:10"
ovs-vsctl set Interface dpdk2 options:n_rxq=1 other_config:pmd-rxq-affinity="0:12"
ovs-vsctl set Interface vhu3f1b2622-91 options:n_rxq=1 other_config:pmd-rxq-affinity="0:14"
ovs-vsctl set Interface vhub77c2502-31 options:n_rxq=1 other_config:pmd-rxq-affinity="0:16"


# E810-VM
ovs-vsctl set Interface dpdk3 options:n_rxq=1 other_config:pmd-rxq-affinity="0:11"
ovs-vsctl set Interface dpdk4 options:n_rxq=1 other_config:pmd-rxq-affinity="0:11"
ovs-vsctl set Interface vhu2d124858-0e options:n_rxq=1 other_config:pmd-rxq-affinity="0:15"
ovs-vsctl set Interface vhub77c2502-31 options:n_rxq=1 other_config:pmd-rxq-affinity="0:17"

# Management port of E810-VM and MLXc6-VM
for i in dpdk0 vhu20e31bdd-81 vhuae423170-14; do ovs-vsctl set Interface $i options:n_rxq=1 other_config:pmd-rxq-affinity="0:19"; done
