#!/bin/bash
ps aux | grep udpServerTiempos | grep -v grep
# if not found - equals to 1, start it
if [ $? -eq 1 ];
then
        echo "eq 1"
        #/etc/init.d/serverTiX-production start
        sudo python /home/pfitba/tix_production/udpServerTiempos.py
else
        echo "eq 0 - udpServerTiempos running - do nothing"
fi
