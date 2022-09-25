#!/usr/bin/env python3
import subprocess
import sys
import os


def main():
    if len(sys.argv) > 1:
        if os.path.isdir(sys.argv[1]):
            path_start = sys.argv[1]
        else:
            path_start = os.path.dirname(sys.argv[1])
        subprocess.Popen(["matlab", "-desktop", "-sd", path_start])
    else:
        subprocess.Popen(["matlab", "-desktop", "-useStartupFolderPref"])


if __name__ == "__main__":
    main()
