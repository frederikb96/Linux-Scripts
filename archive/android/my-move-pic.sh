#!/bin/sh
echo "Start"
dirUnsorted="/sdcard/Pictures/APictures/2022/00_Unsorted/"
find /sdcard/DCIM/Camera -type f -exec mv "{}" "$dirUnsorted" \;
find /sdcard/Pictures/Screenshots -type f -exec mv "{}" "$dirUnsorted" \;
find /sdcard/Pictures -maxdepth 1 -type f -name "*signal*" -exec mv "{}" "$dirUnsorted" \;
find /sdcard/Movies -maxdepth 1 -type f -name "*signal*" -exec mv "{}" "$dirUnsorted" \;
echo "End"
