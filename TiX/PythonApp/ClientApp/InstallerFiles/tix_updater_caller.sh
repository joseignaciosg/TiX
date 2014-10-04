#!/usr/bin/env bash
line="0 0 * * * /etc/TIX/app/tix_updater.sh" 
echo "$line" | sudo crontab -
