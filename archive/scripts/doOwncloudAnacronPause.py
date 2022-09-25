#!/usr/bin/env python3

import sys


path_file = "/home/freddy/.anacron/etc/anacrontab"
string_find = "backup_pi"


def main():
    file_cron = open(path_file, "r")
    lines_cron = file_cron.readlines()
    file_cron.close()
    print("Anacron read")

    file_changed = False
    for i in range(len(lines_cron)):
        if lines_cron[i].find(string_find) != -1:
            if sys.argv[1] == "on" and lines_cron[i][0] != "#":
                lines_cron[i] = "#" + lines_cron[i]
                file_changed = True
                print("Commented")
            elif sys.argv[1] == "off" and lines_cron[i][0] == "#":
                lines_cron[i] = lines_cron[i][1:]
                file_changed = True
                print("Uncommented")

    if file_changed:
        file_cron = open(path_file, "w")
        file_cron.writelines(lines_cron)
        print("Anacron written")
        file_cron.close()
    print("Done!")


if __name__ == "__main__":
    main()

