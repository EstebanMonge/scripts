#!/bin/bash
# Show wich disks are free in zLinux

IFS=$'\n'
used_disks=''
lsdasd_output=$(lsdasd -a | awk '{print $1,$3}' |  grep -v 'Name' | grep -v "=")
for pvs in $(pvs| awk '{print $1,$2}' | sed -e 's/\/dev\///g' -e 's/[0-9]//g'| grep -v "PV")
do
#        for disk in $(lsdasd -a | awk '{print $1,$3}' |  grep -v 'Name' | grep -v "=")
        for disk in $lsdasd_output 
        do
                disk_id=$(echo $disk | awk '{print $1}')
                disk_name=$(echo $disk | awk '{print $2}')
		pv_name=$(echo $pvs | awk '{print $1}')
		vg_name=$(echo $pvs | awk '{print $2}')
                if [[ $disk_name == $pv_name ]]
                then
			echo "$disk_name with id $disk_id is used by $vg_name"
                        used_disks=$used_disks"$disk_name "
                fi
        done
done
for standard in $(cat /proc/mounts |grep -v "mapper\|proc\|sys\|devpts\|tmpfs\|rootfs\|autofs" | awk '{print $1,$2}')
do
#	for disk in $(lsdasd -a | awk '{print $1,$3}' |  grep -v 'Name' | grep -v "=")
        for disk in $lsdasd_output 
	do
                disk_id=$(echo $disk | awk '{print $1}')
                disk_name=$(echo $disk | awk '{print $2}')
		standard_name=$(echo $standard | awk '{print $1}'|sed -e 's/\/dev\///g' -e 's/[0-9]//g')
		mountpoint_name=$(echo $standard | awk '{print $2}')
                if [[ $disk_name == $standard_name ]]
                then
                        echo "$standard_name with id $disk_id is used by $mountpoint_name"
                        used_disks=$used_disks"$disk_name "
                fi
	done
done

for swaps in $(cat /proc/swaps | grep -v "Filename" | awk '{print $1}' | sed -e 's/\/dev\///g' -e 's/[0-9]//g')
do
#        for disk in $(lsdasd -a | awk '{print $1,$3}' |  grep -v 'Name' | grep -v "=")
        for disk in $lsdasd_output 
        do
                disk_id=$(echo $disk | awk '{print $1}')
                disk_name=$(echo $disk | awk '{print $2}')
                if [[ $disk_name == $swaps ]]
                then
                        echo "$swaps with id $disk_id is used by swap"
                        used_disks=$used_disks"$disk_name "
                fi
        done
done

for disk in $(lsdasd -a | awk '{print $1,$3}' |  grep -v 'Name' | grep -v "=")
do
        disk_id=$(echo $disk | awk '{print $1}')
        disk_name=$(echo $disk | awk '{print $2}')
        if [[ $used_disks != *$disk_name* ]]
        then
                echo "$disk_name with id $disk_id is free"
        fi
        if [[ $disk_name == "" ]]
        then
                echo "Disk with id $disk_id is free"
        fi
done
