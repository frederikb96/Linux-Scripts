#!/usr/bin/env python3

def main():
	print("Open file")
	file = open("./cal.ics", "r")
	text = file.readlines()
	file.close()

	print("Start process")
	i = 0
	line_start = -1
	found_identifier = False
	matches = ["Datenstrukturen", "Datenbanken", "Datenkommunikation", "Business", "Reinforcement", "Algorithmic"]
	for k in range(len(text)):

		# Check for start phrase
		if text[i].__contains__("BEGIN:VEVENT"):
			line_start = i

		# if start phrase found, check for further cases
		if line_start != -1:
			# check if identifier found
			if any(x in text[i] for x in matches):
				found_identifier = True

			# check if already found end phrase
			if text[i].__contains__("END:VEVENT"):
				# if identifier found, delete the lines
				if found_identifier:
					# delete lines
					text = text[:line_start] + text[i+1:]
					# fix index, since lines deleted
					i -= (i - line_start + 1)
				# Reset line Start again
				line_start = -1
				found_identifier = False
		i += 1

	# Save new text
	file_out = open("cal_new.ics", "w")
	file_out.writelines(text)
	file_out.close()
	print("Saved")


if __name__ == "__main__":
	main()
	
