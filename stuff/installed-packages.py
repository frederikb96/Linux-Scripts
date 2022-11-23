#!/usr/bin/env python3
import subprocess
import sys
import os


def main():

    file_config = open("packages.txt", "r")
    lines_config = file_config.readlines()
    file_config.close()
    print("Config read")

    lines = ""
    for i in range(len(lines_config)):

        line = lines_config[i][37:]
        b = line.find(" ")
        line = line[:b]
        lines = lines + " " + line

    print(lines)







if __name__ == "__main__":
    main()
