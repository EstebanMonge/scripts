#!/bin/bash
# Show wich disks are free in one zLinux
# Only works with LVM setup based
# Tested in Suse Linux 11

IFS=$'\n'
used_disks=''
for pvs in $(pvs| awk '{print $1}' | sed -e 's/\/dev\///g' -e 's/[0-9]//g'| grep -v "PV")
do
        for disk in $(lsdasd -a | awk '{print $1,$3}' |  grep -v 'Name' | grep -v "=")
        do
                disk_id=$(echo $disk | awk '{print $1}')
                disk_name=$(echo $disk | awk '{print $2}')
                if [[ $disk_name == $pvs ]]
                then
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
                echo "Disk with id $disk_id is free"
        fi
        if [[ $disk_name == "" ]]
        then
                echo "Disk with id $disk_id is free"
        fi
done

