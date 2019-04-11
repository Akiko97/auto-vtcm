#!/bin/bash
uuid=`sudo dmidecode | grep UUID | awk {'print $2'}`
echo $uuid > ./cube-1.3/proc/plugin/uuid
