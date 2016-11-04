#!/bin/bash

#centos7のインストール			
#使い方　rootユーザで、./install.sh 引数1
#引数1 はvm名を指定

virt-install \
--name=$1 \
--vcpus=1 \
--ram=1024 \
--location=/tmp/CentOS-7-x86_64-Minimal-1511.iso \
--disk path=/var/lib//libvirt/images/$1.img,format=qcow2,size=8 \
--network bridge=virbr0 \
--arch=x86_64 \
--os-type=linux \
--os-variant=rhel7
--graphics none \
--extra-args='console=tty0 console=ttyS0,115200n8 keymap=ja'
exit 0
