#!/usr/bin/env python3

import os
import subprocess

pathSignal = "sdcard/Signal/Backups/"
pathPc = "/home/freddy/Backup/owncloud/Archive/00_Signal/"

def main():
    # Check pc folder
    if not os.path.isdir(pathPc):
        raise Exception("Pc path does not exist")
    filesPcOld = os.listdir(pathPc)

    res = subprocess.run(["adb", "root"])
    if res.returncode != 0:
        raise Exception("ADB root not running")
    res = subprocess.run(["adb", "shell", "ls", pathSignal], capture_output=True, text=True)
    if res.returncode != 0:
        raise Exception("Not possible to read phone signal folder")
    print("Files found:\n", res.stdout)
    filesSignal = res.stdout.splitlines()

    if len(filesSignal) > 2:
        raise Exception("More than two files found for backup")

    if len(filesSignal) < 1:
        raise Exception("No files available for backup")

    fileBackup = filesSignal[-1]

    print("Do Backup of:", fileBackup)

    res = subprocess.run(["adb", "pull", pathSignal + fileBackup, pathPc], capture_output=True, text=True)
    if res.returncode != 0:
        raise Exception("Backup not successful")
    print("Backup done", res.stdout.splitlines()[-1])

    print("Delete old ones on PC:")
    for fileDelete in filesPcOld:
        if fileDelete != fileBackup:
            pathDelete = os.path.join(pathPc, fileDelete)
            os.remove(pathDelete)
            print("Deleted: ", pathDelete)

    print("Delete all on handy:")
    for fileDelete in filesSignal:
        res = subprocess.run(["adb", "shell", "rm", pathSignal + fileDelete], capture_output=True, text=True)
        if res.returncode != 0:
            raise Exception("Deletion of signal files not successful")
        print("Deleted: ", fileDelete)
        
if __name__ == '__main__':
    main()

