#!/usr/bin/env bash

#setting it at 12am
line="0 0 * * * /etc/TIX/app/tix_updater.sh" 

 echo "$line" | crontab -u $USER -

 crontab -u $USER -l;