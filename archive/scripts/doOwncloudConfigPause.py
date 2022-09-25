#!/usr/bin/env python3

import sys


path_file = "/home/freddy/.config/ownCloud/owncloud.cfg"
string_find = "/home/freddy/Backup/"

if sys.argv[1] == "on":
	string_find_next = "paused=false"
	string_replace = "paused=true"
else:
	string_find_next = "paused=true"
	string_replace = "paused=false"


def main():
	file_config = open(path_file, "r")
	lines_config = file_config.readlines()
	file_config.close()
	print("Config read")

	file_changed = False
	for i in range(len(lines_config)):
		if lines_config[i].find(string_find) != -1:
			n = i + 1
			while n < len(lines_config):
				if lines_config[n].find(string_find_next) != -1:
					lines_config[n] = lines_config[n].replace(string_find_next, string_replace)
					file_changed = True
					print("Pause found")
					break
				n += 1

	if file_changed:
		file_config = open(path_file, "w")
		file_config.writelines(lines_config)
		print("Config written")
		file_config.close()
	print("Done!")


if __name__ == "__main__":
	main()
	
