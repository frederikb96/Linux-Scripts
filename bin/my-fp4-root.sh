#!/bin/bash

# This script can be used to automatically root your FP4 with /e/OS installed again after you updated the OS version via the build in updater, which removed the root via magisk
# Adapted from https://github.com/NicolasWebDev/reinstall-magisk-on-lineageos/blob/main/reinstall-magisk-on-lineageos

clean_up_pc() {
  cd ..
  rm -rf tmp-fp4-root
}

clean_up_phone() {
  adb shell rm /sdcard/Download/boot.img
  adb shell rm /sdcard/Download/patched-boot.img
}

check_adb() {
	echo "Check if adb root is running"
	until adb root; do
		if ((SECONDS > 60)); then
		    echo "Timeout: No devices connected!"
		    exit 1
		fi
		echo "Phone is not in adb root mode...waiting..."
		sleep 2
	done
}

check_fastboot() {
	echo "Wait until device is in fastboot mode"
	SECONDS=0
	until (fastboot devices | grep fastboot); do

		if ((SECONDS > 60)); then
		    echo "Timeout, device not in fastboot mode"
		    clean_up_pc
		    exit 2
		fi

		echo "Phone is not in fastboot mode yet. Waiting..."
		sleep 5
	done
}

#-------------------------------------------------
# Device connected?
#-------------------------------------------------
check_adb

#-------------------------------------------------
# Create temporary directory
#-------------------------------------------------
echo "Creat tmp directory for boot.img"
mkdir ./tmp-fp4-root
cd tmp-fp4-root || exit 1

#-------------------------------------------------
# Get FP4 boot image
#-------------------------------------------------
echo "Get image file from fp4 repo"
a=$(curl https://images.ecloud.global/stable/FP4/)
b=${a%%FP4.zip*}"FP4.zip"
c="IMG""${b#*href=IMG}"
echo "Get" "https://images.ecloud.global/stable/FP4/""$c"
curl --location "https://images.ecloud.global/stable/FP4/""$c" --output ./fp4-img.zip
unzip ./fp4-img.zip -d ./fp4-img

# Extract boot image
echo "Extract boot.img"
mv fp4-img/boot.img ./boot.img
if [ "$?" -ne "0" ]; then echo "Image could not be downloaded"; clean_up_pc; exit 1; fi;

#-------------------------------------------------
# Patch image via phone
#-------------------------------------------------
echo "Push image and patch it"
adb push ./boot.img /sdcard/Download/boot.img
adb shell /data/adb/magisk/boot_patch.sh /sdcard/Download/boot.img
if [ "$?" -ne "0" ]; then echo "Image could not be patched"; clean_up_pc; clean_up_phone; exit 1; fi;
adb shell mv /data/adb/magisk/new-boot.img /sdcard/Download/patched-boot.img
adb pull /sdcard/Download/patched-boot.img ./

echo "Clean up image on phone"
clean_up_phone

#-------------------------------------------------
# Flash image
#-------------------------------------------------
echo "Reboot to bootloader"
adb reboot bootloader

check_fastboot

echo "Boot the patched image, shall we start?"
read
echo "Really?"
read

fastboot boot ./patched-boot.img


#-------------------------------------------------
# Device connected?
#-------------------------------------------------
check_adb

echo
echo "Check if everything is working...."
echo

echo "Ready and all fine?"
read
echo "Ok lets go"
adb reboot bootloader
check_fastboot

echo
echo "Really flash the patched image, shall we start?"
read
echo "Really?"
read

fastboot flash boot ./patched-boot.img

echo "Reboot"
fastboot reboot

#-------------------------------------------------
# Clean up
#-------------------------------------------------
echo "Clean up PC folder"
clean_up_pc
