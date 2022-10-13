#!/usr/bin/env python3
import subprocess
import sys
import os
from urllib.parse import quote

# ---------------------------------------------------------------------------------------------------------------------#
# This script enables you to use Obsidian to open any file without a vault
# It symlinks the folder containing the file you want to open to a temporary vault which must exist, though
# First, it checks if the file is already part of a vault. If this is the case, it opens it normally.
# You can also disable this option, by adding "off" as a first argument to the command line. In this case, it only
# opens files, which are part of a vault. Others are getting opened in "gedit".
# ---------------------------------------------------------------------------------------------------------------------#

tmp_dir = "/home/"+os.getlogin()+"/Documents/ObsidianTmp/"
config_path = "/home/" + os.getlogin() + "/.config/obsidian/obsidian.json"


# Clean up symlinks in the tmp vault
def clean_tmp():
    for (root, dirs, files) in os.walk(tmp_dir):
        for file in files:
            if file.__contains__(".md"):
                os.remove(os.path.join(root, file))
        for directory in dirs:
            if directory.__contains__(".md"):
                os.remove(os.path.join(root, directory))
        break


# Create symlink and also recreate already existing ones
def symlink_force(target, link_name):
    if os.path.exists(link_name):
        os.remove(link_name)
        os.symlink(target, link_name)
    else:
        os.symlink(target, link_name)


def main():
    always_link = True
    if len(sys.argv) > 1 and sys.argv[1] == "off":
        always_link = False

    # Check if the script is called with any argument (file path)
    if len(sys.argv) > 2 or (len(sys.argv) > 1 and always_link):
        # Only proceed if file is a markdown file
        if len(sys.argv) > 2:
            current_file = sys.argv[2]
        else:
            current_file = sys.argv[1]
        if not current_file.__contains__(".md"):
            exit("Not a markdown file")

        # Walk up the directory structure and check if there is a .obsidian folder, which means that there is a vault
        current_dir = os.path.dirname(current_file)
        vault_path = None
        while current_dir != "/":
            for (root, dirs, files) in os.walk(current_dir):
                for directory in dirs:
                    if directory == ".obsidian":
                        # Vault found, break
                        vault_path = root
                        break
                break
            if vault_path is None:
                # No vault found, go a level higher
                current_dir = os.path.dirname(current_dir)
            else:
                # Vault found, break also outer loop
                break

        # If vault found, check if it is also registered in Obsidian
        if vault_path is not None:
            if os.path.isfile(config_path):
                config_file = open(config_path, "r")
                config_txt = config_file.read()
                config_file.close()
                if not config_txt.__contains__(vault_path):
                    # Vault not registered
                    vault_path = None
            else:
                # No config, means no vault at all
                vault_path = None

        # Check if file is part of vault
        if vault_path is None:
            # Check if you want to try linking and open in obsidian and if tmp vault available
            if always_link and os.path.isdir(tmp_dir):
                # Not part of any vault, symlink to tmp vault and open there
                current_dir = os.path.dirname(current_file)
                current_file_link = \
                    tmp_dir + os.path.basename(current_dir) + "_" + os.path.basename(current_file).split('.')[0]
                # Need to change path to URI format
                current_file_link_quote = quote(current_file_link + "/" + os.path.basename(current_file), safe='')
                # Symlink directory of file to tmp vault
                symlink_force(current_dir, current_file_link)
                # Open symlinked file in tmp vault
                process_obsidian = subprocess.Popen(["xdg-open", "obsidian://open?path=" + current_file_link_quote])
                process_obsidian.wait()
                # Waiting until Obsidian closed not working, since xdg-open is creating another independent subprocess
                # clean_tmp()
            else:
                # No linking or no tmp vault, so cannot open file and only open normally
                subprocess.Popen(["gedit", current_file])
        else:
            # Open file normally, since vault found
            current_file_quote = quote(current_file, safe='')
            subprocess.Popen(["xdg-open", "obsidian://open?path=" + current_file_quote])

    else:
        subprocess.Popen(["xdg-open", "obsidian://open"])


if __name__ == "__main__":
    main()
