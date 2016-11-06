#!/bin/bash

#仮想マシンの電源OFF			
#使い方　rootユーザで、./destroying.sh 引数1
#引数1 はvm名を指定

virsh destroy $1
exit 0
