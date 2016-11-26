#!/bin/bash

work_dir=/tmp/$1
 
cmd_awk=/bin/awk
cmd_cat=/bin/cat
cmd_cut=/bin/cut
cmd_grep=/bin/grep
cmd_mkdir=/bin/mkdir
cmd_sed=/bin/sed
cmd_uuidgen=/usr/bin/uuidgen
cmd_virsh=/usr/bin/virsh
cmd_virt_cat=/usr/bin/virt-cat
cmd_virt_clone=/usr/bin/virt-clone
cmd_virt_copy_in=/usr/bin/virt-copy-in
cmd_echo=/bin/echo
 
original_domain_name=guest02
original_fqdn=${original_domain_name}
original_ipaddr=192.168.1.102
source_bridge=br0
clone_domain_name=$1
clone_fqdn=${clone_domain_name}
clone_ipaddr=$4
clone_cpus=$2
clone_memorys=$3
clone_authorized_keys=$5
 
domain_image_dir=/var/lib/libvirt/images
clone_domain_image_path=$domain_image_dir/"${clone_domain_name}.img"
 
# --------------------------------------------------
# pre process.
# --------------------------------------------------
 
if [ "$clone_domain_name" = "" -o "$clone_cpus" = "" -o "clone_memorys" = "" -o "$clone_ipaddr" = "" ] ; then
echo "Usage initializing.sh <domain_name> <cpus> <memorys> <ipaddr>"
exit 0
fi
 
[ ! -e $work_dir ] && $cmd_mkdir -p $work_dir
 
# --------------------------------------------------
# main process.
# --------------------------------------------------
$cmd_virt_clone                                               \
  --original $original_domain_name                            \
  --name $clone_domain_name                                   \
  --file $clone_domain_image_path
 
# ----- /etc/hosts -----
$cmd_virt_cat -d $original_domain_name /etc/hosts             \
  > $work_dir/hosts.org
$cmd_cat $work_dir/hosts.org                                  \
  | $cmd_sed "s/$original_fqdn/$clone_fqdn/"                  \
  > $work_dir/hosts
$cmd_virt_copy_in -d $clone_domain_name $work_dir/hosts /etc/
 
# ----- /etc/sysconfig/network ------
$cmd_virt_cat -d $original_domain_name /etc/sysconfig/network \
  > $work_dir/network.org
$cmd_cat $work_dir/network.org                                \
  | $cmd_sed "s/$original_fqdn/$clone_fqdn/"                  \
  > $work_dir/network
$cmd_virt_copy_in -d $clone_domain_name $work_dir/network /etc/sysconfig/
 
# ----- /etc/sysconfig/network-scripts/ifcfg-eth0 ------
$cmd_virt_cat -d $original_domain_name                        \
  /etc/sysconfig/network-scripts/ifcfg-eth0                   \
  > $work_dir/ifcfg-eth0.org

original_mac_addr=$(                                          \
$cmd_virsh domiflist $original_domain_name                    \
| $cmd_grep $source_bridge                                    \
| $cmd_awk '{print $5}'                                       \
)
clone_mac_addr=$(                                             \
$cmd_virsh domiflist $clone_domain_name                       \
| $cmd_grep $source_bridge                                    \
| $cmd_awk '{print $5}'                                       \
)
 
original_nic_uuid=$(                                          \
$cmd_cat $work_dir/ifcfg-eth0.org                             \
| $cmd_grep -i uuid                                           \
| $cmd_cut -d'=' -f2                                          \
| $cmd_sed 's/"//g'                                           \
)
clone_nic_uuid=$($cmd_uuidgen)
 
$cmd_cat $work_dir/ifcfg-eth0.org                             \
| $cmd_sed -e "s/$original_mac_addr/$clone_mac_addr/i"        \
-e "s/$original_nic_uuid/$clone_nic_uuid/i"                   \
-e "s/$original_ipaddr/$clone_ipaddr/i"                       \
> $work_dir/ifcfg-eth0
$cmd_virt_copy_in -d $clone_domain_name                       \
  $work_dir/ifcfg-eth0                                        \
  /etc/sysconfig/network-scripts/
 
# ----- /etc/udev/rules.d/70-persistent-net.rules -----
$cmd_virt_cat -d $original_domain_name                        \
  /etc/udev/rules.d/70-persistent-net.rules                   \
  > $work_dir/70-persistent-net.rules.org
$cmd_cat $work_dir/70-persistent-net.rules.org                \
  | $cmd_sed "s/$original_mac_addr/$clone_mac_addr/i"         \
  > $work_dir/70-persistent-net.rules
$cmd_virt_copy_in -d $clone_domain_name                       \
  $work_dir/70-persistent-net.rules                           \
  /etc/udev/rules.d/

# ----- /root/.ssh/authorized_keys ------
$cmd_mkdir $work_dir/.ssh
$cmd_echo $clone_authorized_keys > $work_dir/.ssh/authorized_keys
$cmd_virt_copy_in -d $clone_domain_name $work_dir/.ssh /root

# ----- /etc/libvirt/qemu/.xml edit -----
$cmd_sed -i -e "s/\/var\/lib\/libvirt\/qemu\/channel\/target\/domain-guest../\/var\/lib\/libvirt\/qemu\/channel\/target\/domain-$clone_domain_name/g" /etc/libvirt/qemu/$clone_domain_name.xml
$cmd_sed -i -e "s/\<memory unit=\'KiB\'\>1048576\<\/memory\>/\<memory unit=\'KiB\'\>$clone_memorys\<\/memory\>/g" /etc/libvirt/qemu/$clone_domain_name.xml
$cmd_sed -i -e "s/1048576/$clone_memorys/g" /etc/libvirt/qemu/$clone_domain_name.xml
$cmd_sed -i -e "s/1<\/vcpu>/$clone_cpus<\/vcpu>/g" /etc/libvirt/qemu/$clone_domain_name.xml

$cmd_virsh define /etc/libvirt/qemu/$clone_domain_name.xml
exit 0
