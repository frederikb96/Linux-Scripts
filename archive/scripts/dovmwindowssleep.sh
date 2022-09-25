#!/bin/bash

vmplayer /home/freddy/vmware/Windows2/Windows2.vmx

zenity --warning --timeout=40 --text="Press something to cancel sleep!"
if [ $? -eq 5 ]; then systemctl suspend; fi

exit 0
