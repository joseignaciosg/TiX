#!/usr/bin/env bash
line="0 0 * * * bash -l -c 'nohup /etc/TIX/app/tix_updater.sh&'" 
echo "$line" | sudo crontab -
