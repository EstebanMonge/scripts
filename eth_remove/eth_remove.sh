#!/bin/bash

lib_path="/var/lib/eth_remove"

if [ ! -d $lib_path ]
then
        mkdir $lib_path
fi

iface=$(whiptail --title 'ETH remove' --radiolist 'Temporary disable physical network interface, please choose one' 20 78 4 $(for i in $(ls -l /sys/class/net/| grep -v "virtual\|total" | awk '{print $9}'); do echo "$i $i OFF\\"; done) 3>&1 1>&2 2>&3)
path=$(ls -l /sys/class/net/| grep $iface | awk '{print $11}' | sed 's/\.\.\/\.\.\//\/sys\//' | sed 's/net\/'$iface'/remove/')

ip a >> $lib_path/removed_eth

echo $iface $path >> $lib_path/removed_eth

echo 1 > $path
