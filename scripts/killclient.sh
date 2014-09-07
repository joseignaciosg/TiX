#!/bin/bash





for i in $(ps aux | grep "/etc/TIX/app/TixClientApp" | grep -v grep | awk '{ print $2 }' | sort -n)
do 
	echo killing process with pid ${i}
	kill -9 ${i}
done
