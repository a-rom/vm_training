#!/bin/bash

#仮想マシンの電源ON(起動)
#使い方　rootユーザで、./starting.sh 引数1
#引数1 はvm名を指定

virsh start $1
exit 0
