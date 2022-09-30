#!/usr/bin/env python3
import subprocess
import sys
import os
from urllib.parse import quote


tmp_dir = "/home/"+os.getlogin()+"/Documents/ObsidianTmp/"


def clean_tmp():
    for (root, dirs, files) in os.walk(tmp_dir):
        for file in files:
            if file.__contains__(".md"):
                os.remove(os.path.join(root, file))
        break


def symlink_force(target, link_name):
    if os.path.exists(link_name):
        os.remove(link_name)
        os.symlink(target, link_name)
    else:
        os.symlink(target, link_name)


def main():
    if len(sys.argv) > 1:
        current_file = sys.argv[1]
        if not current_file.__contains__(".md"):
            exit("Not a markdown file")

        current_dir = os.path.dirname(current_file)
        vault_path = None
        while current_dir != "/":
            for (root, dirs, files) in os.walk(current_dir):
                for directory in dirs:
                    if directory == ".obsidian":
                        vault_path = root
                        break
                break
            if vault_path is None:
                current_dir = os.path.dirname(current_dir)
            else:
                break

        if vault_path is None:
            # clean_tmp()

            current_file_link = tmp_dir + os.path.basename(current_file)
            current_file_link_quote = quote(current_file_link, safe='')
            symlink_force(current_file, current_file_link)
            subprocess.Popen(["xdg-open", "obsidian://open?path=" + current_file_link_quote])
        else:
            current_file_quote = quote(current_file, safe='')
            subprocess.Popen(["xdg-open", "obsidian://open?path=" + current_file_quote])

    else:
        subprocess.Popen(["xdg-open", "obsidian://open"])


if __name__ == "__main__":
    main()
