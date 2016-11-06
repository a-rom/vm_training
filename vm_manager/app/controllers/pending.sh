#!/bin/bash

#仮想マシンの一時停止
#使い方　rootユーザで、./pending.sh 引数1
#引数1 はvm名を指定

virsh suspend $1
exit 0
