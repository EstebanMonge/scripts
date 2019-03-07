#!/bin/bash
# Esteban Monge estebanmonge@riseup.net
# https://github.com/estebanmonge/scripts
# GBM Corporation
# 2019
case $1 in
        hosts)
                status=$(/usr/sbin/pcs status | grep OFFLINE)
                if [[ $status == *"OFFLINE"* ]]
                then
                        echo $status| sed -e "s/:/|/" -e "s/ \[ //g" -e "s/\]//g"
                else
                        /usr/sbin/pcs status | grep Online | sed -e "s/:/|/" -e "s/ \[ //g" -e "s/\]//g"
                fi
                ;;
        resources)
                /usr/sbin/pcs status | grep -e "Started" -e  "Stopped" | awk '{ print $1"|"$3"|"$4}'
                ;;
        *) echo "This script check pcs status and parse to get:"
           echo "Use hosts to get the state of the hosts of cluster"
           echo "Use resources to get the state of the resources of cluster"
	   echo "The use principally is for IBM Tivoli Monitoring"
esac
