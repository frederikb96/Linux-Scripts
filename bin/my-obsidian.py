#!/usr/bin/env python3
import subprocess
import sys
import os


def main():
    if len(sys.argv) > 1:
        current_dir = os.path.dirname(sys.argv[1])
        vault_path = None
        while True:
            for (root, dirs, files) in os.walk(current_dir):
                for dir in dirs:
                    if dir == ".obsidian":
                        vault_path = root
                        break
                break
            if vault_path is None:
                current_dir = os.path.dirname(current_dir)
            else:
                break



        subprocess.Popen(["matlab", "-desktop", "-sd", path_start])
    else:
        subprocess.Popen(["matlab", "-desktop", "-useStartupFolderPref"])


if __name__ == "__main__":
    main()
