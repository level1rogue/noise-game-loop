extends Node

func convert_int_to_string(og_number, digits):
	if og_number < (10^(digits-1))-1:
		var int_str := ""
		for i in (digits-1):
			int_str += "0"
		return int_str + str(og_number)
	else:
		return str(og_number)
