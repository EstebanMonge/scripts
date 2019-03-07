#!/bin/bash
# Esteban Monge estebanmonge@riseup.net
# https://github.com/estebanmonge/scripts
# GBM Corporation
# 2019
sudo -H -u db2inst1 bash -c "/opt/ibm/db2/V10.5/bin/asnqccmd capture_server=MFPDATA2 capture_schema="ASN" status show details"|grep  ACTIVE_QSUBS |awk '{print $6"|"$8}'| sed -e "s/(//" -e "s/)//g"
