#!/bin/bash

zenity --question --text="Do you want to Backup?"
if [ $? -eq 1 ]; then exit 0; fi


gnome-terminal -e doowncloudsecondbackup.sh

exit 0
