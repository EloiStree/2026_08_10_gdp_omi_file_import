class_name OmiFileAbInputAnalogParser
extends Node

signal on_request_analog_input_parsed(
	source_name: String,
	source_min_value: float,
	source_max_value: float,
	destination_min_value: float,
	destination_max_value: float,
	death_zone_min_value: float,
	death_zone_max_value: float,
	destination_name: String
)

@export var _use_print_debug:bool

func push_in_text_to_parse(text:String):
	text = text.to_lower()
	var lines = text.split("\n")
	for line in lines:
		line = line.strip_edges()
		if line == "":
			continue
		var parts = line.split("♦️")
		if parts.size() < 8:
			continue
		for i in range(parts.size()):
			parts[i] = parts[i].strip_edges()

		if parts[1].is_valid_float() and parts[2].is_valid_float() and parts[3].is_valid_float() and parts[4].is_valid_float() and parts[5].is_valid_float() and parts[6].is_valid_float():
			var source_name= parts[0]
			var source_min_value = float(parts[1])
			var source_max_value = float(parts[2])
			var destination_min_value = float(parts[3])
			var destination_max_value = float(parts[4])
			var death_zone_min = float(parts[5])
			var death_zone_max = float(parts[6])
			var destination_name:String = parts[7]
			on_request_analog_input_parsed.emit(source_name, source_min_value, source_max_value, destination_min_value, destination_max_value, death_zone_min ,death_zone_max, destination_name)
			if _use_print_debug:
				print("source_name: ", source_name, " source_min_value: ", source_min_value, " source_max_value: ", source_max_value, " destination_min_value: ", destination_min_value, " destination_max_value: ", destination_max_value, \
				death_zone_min, death_zone_max, " destination_name: ", destination_name)
		else:
			continue
		


# NameSource♦️0♦️65535♦️1♦️-1♦️destination
