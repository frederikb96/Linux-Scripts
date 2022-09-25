#!/bin/bash


echo "grep"
mount |grep "/home/freddy/vmware on /home/freddy/vmware"

if [ $? -ne 0 ]; then

  echo "mount"
  pkexec mount -o multithreaded -t fuse.bindfs /home/freddy/vmware /home/freddy/vmware

  if [ $? -ne 0 ]; then

    echo "Bindfs mount failed. Please check if bindfs is correctly installed."

    exit 1

  fi

fi

echo "Start VM"

{
vmplayer -X /home/freddy/vmware/Windows2/Windows2.vmx
} > /home/freddy/Documents/vmware.log 2>&1

pkexec umount -v /home/freddy/vmware



exit 0
