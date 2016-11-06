#!/bin/bash

#仮想マシンの再起動
#使い方　rootユーザで、./rebooting.sh 引数1
#引数1 はvm名を指定

virsh reboot $1
exit 0
