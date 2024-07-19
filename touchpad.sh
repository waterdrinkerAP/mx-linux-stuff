#!/bin/bash

declare -i ID
ID=`xinput list | grep -Eo '[Tt]ouch[Pp]ad\s*id\=[0-9]{1,2}' | grep -Eo '[0-9]{1,2}'`
declare -i STATE
STATE=`xinput list-props $ID|grep 'Device Enabled'|awk '{print $4}'`
if [ $STATE -eq 1 ]
then
    xinput disable $ID
    notify-send --icon=/usr/share/icons/Adwaita/32x32/devices/input-touchpad-symbolic.symbolic.png "Touchpad disabled."
else
    xinput enable $ID
    notify-send --icon=/usr/share/icons/Adwaita/32x32/devices/input-touchpad-symbolic.symbolic.png "Touchpad enabled."
fi
