#!/bin/bash

#仮想マシンの再開
#使い方　rootユーザで、./resuming.sh 引数1
#引数1 はvm名を指定

virsh resume $1
exit 0
