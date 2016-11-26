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
cmd_rm=/bin/rm

clone_domain_name=$1
 
domain_image_dir=/var/lib/libvirt/images
clone_domain_image_path=$domain_image_dir/"${clone_domain_name}.img"
 
 
# --------------------------------------------------
# main process.
# --------------------------------------------------

$cmd_virsh undefine $clone_domain_name
$cmd_virsh vol-delete $clone_domain_image_path

$cmd_rm -rf $work_dir

exit 0


