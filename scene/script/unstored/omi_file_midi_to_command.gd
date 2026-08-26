class_name OmiFileMidiToCommand
extends Node



signal on_any_device_control_received(
	control_0_127:int,
	value_min_0_127:int,
	value_max_0_127:int,
	is_in_range:bool,
	command:String)


signal on_any_device_note_received(
	channel_0_15:int,
	note_0_127:int,
	value_min_0_127:int,
	value_max_0_127:int,
	is_in_range:bool,
	command:String)


signal on_specific_device_control_received(
	device_name:String,
	control_0_127:int,
	value_min_0_127:int,
	value_max_0_127:int,
	is_in_range:bool,
	command:String)


signal on_specific_device_note_received(
	device_name:String,
	channel_0_15:int,
	note_0_127:int,
	value_min_0_127:int,
	value_max_0_127:int,
	is_in_range:bool,
	command:String)
	



@export var _replace_true_by_midi_velocity:String ="70-127"
@export var _replace_false_by_midi_velocity:String ="0-20"

func push_in_text_to_parse(text:String):
	var lines :PackedStringArray = text.split("\n")
	for line in lines:
		line = line.strip_edges()
		if line.begins_with("#"):
			continue
		if not line.is_empty():
			var parts:PackedStringArray = line.split("♦")
			var count:int = parts.size()
			if count>=5:
				var device_name_str:String = ""
				var type_of_data_str:String = ""
				var channel_str:String = ""
				var note_str:String = ""
				var velocity_range_str:String = ""
				var in_out_str:String = ""
				var command_str:String = ""

				if is_first_cell_note_tag(line.split("♦")):
					print(">>MIDI NOTE>>> ", line)
					# note ♦️9♦️50♦️127-70♦️in♦️ cmd:log xbox boolean A true
					
					process_midi_note_info_str(
						"",
						parts[1].strip_edges(),
						parts[2].strip_edges(),
						parts[3].strip_edges(),
						parts[4].strip_edges(),
						parts[5].strip_edges()
					)
				elif is_second_cell_note_tag(line.split("♦")):
					print(">>MIDI NOTE>>> ", line)
					process_midi_note_info_str(
						parts[0].strip_edges(),
						parts[2].strip_edges(),
						parts[3].strip_edges(),
						parts[4].strip_edges(),
						parts[5].strip_edges(),
						parts[6].strip_edges()
					)

				elif is_first_cell_control_tag(line.split("♦")):
					print(">>MIDI CONTROL>>> ", line)
					process_midi_control_info_str(
						"",
						parts[1].strip_edges(),
						parts[2].strip_edges(),
						parts[3].strip_edges(),
						parts[4].strip_edges()
					)
				elif is_second_cell_control_tag(line.split("♦")):
					print(">>MIDI CONTROL>>> ", line)
					process_midi_control_info_str(
						parts[0].strip_edges(),
						parts[2].strip_edges(),
						parts[3].strip_edges(),
						parts[4].strip_edges(),
						parts[5].strip_edges()
					)
				else:
					print(">>MIDI UNKNOWN>>> ", line)


func process_midi_control_info_str(
	device_name_str:String,
	control_str:String,
	value_min_max_str:String,
	is_in_range_str:String,
	command_str:String
):
	var control_int:int = 0
	if control_str.is_valid_int():
		control_int = clampi(int(control_str), 0, 127)
	var value_split:PackedStringArray = value_min_max_str.split("-")
	var value_min:int = 0
	var value_max:int = 0
	if value_split.size() >= 1:
		if value_split[0].is_valid_int():
			value_min = clampi(int(value_split[0]), 0, 127)
	if value_split.size() >= 2:
		if value_split[1].is_valid_int():
			value_max = clampi(int(value_split[1]), 0, 127)
	if value_min > value_max:
		var temp:int = value_min
		value_min = value_max
		value_max = temp
	var is_in_range:bool = is_in_or_true(is_in_range_str)

	if device_name_str.strip_edges().is_empty():
		on_any_device_control_received.emit(
			control_int,
			value_min,
			value_max,
			is_in_range,
			command_str
		)
	else:
		on_specific_device_control_received.emit(
			device_name_str,
			control_int,
			value_min,
			value_max,
			is_in_range,
			command_str
		)


func process_midi_note_info_str(
	device_name_str:String,
	channel_str:String,
	note_str:String,
	value_min_max_str:String,
	in_out_str:String,
	command_str:String
):
	var channel_int:int = 0
	if channel_str.is_valid_int():
		channel_int = clampi(int(channel_str), 0, 15)
	var note_int:int = 0
	if note_str.is_valid_int():
		note_int = clampi(int(note_str), 0, 127)
	var velocity_split:PackedStringArray = value_min_max_str.split("-")
	var velocity_min:int = 0
	var velocity_max:int = 0
	if velocity_split.size() >=1:
		if velocity_split[0].is_valid_int():
			velocity_min = clampi(int(velocity_split[0]), 0, 127)
	if velocity_split.size() >= 2:
		if velocity_split[1].is_valid_int():
			velocity_max = clampi(int(velocity_split[1]), 0, 127)
	if velocity_min > velocity_max:
		var temp:int = velocity_min
		velocity_min = velocity_max
		velocity_max = temp
	var is_in_range:bool = is_in_or_true(in_out_str)
	if device_name_str.strip_edges().is_empty():
		on_any_device_note_received.emit(
			channel_int,
			note_int,
			velocity_max,
			is_in_range,
			command_str
		)
	else:
		on_specific_device_note_received.emit(
			device_name_str,
			channel_int,
			note_int,
			velocity_max,
			is_in_range,
			command_str
		)



func is_in_or_true(text:String) -> bool:
	var text_lower:String = text.to_lower()
	return text_lower.begins_with("in") or text_lower.begins_with("true")


func is_note_tag(note_tag:String) -> bool:
	var note_tag_lower:String = note_tag.to_lower()
	return note_tag_lower.begins_with("note") or note_tag_lower.begins_with("n")

func is_control_tag(control_tag:String) -> bool:
	var control_tag_lower:String = control_tag.to_lower()
	return control_tag_lower.begins_with("control") or control_tag_lower.begins_with("c")



func is_first_cell_note_tag(array:Array[String]) -> bool:
	if array.size() > 0:
		return is_note_tag(array[0])
	return false

func is_first_cell_control_tag(array:Array[String]) -> bool:
	if array.size() > 0:
		return is_control_tag(array[0])
	return false

func is_second_cell_note_tag(array:Array[String]) -> bool:
	if array.size() > 1:
		return is_note_tag(array[1])
	return false

func is_second_cell_control_tag(array:Array[String]) -> bool:
	if array.size() > 1:
		return is_control_tag(array[1])
	return false




# note ♦️9♦️50♦️127-70♦️in♦️ cmd:log xbox boolean A true
# note ♦️9♦️50♦️127-70♦️out♦️ cmd:log xbox boolean A false

# note ♦️9♦️50♦️20-127♦️in♦️ cmd:log xbox boolean A true
# note ♦️9♦️50♦️0-20♦️in♦️ cmd:log xbox boolean A false

# SINCO ♦️ note ♦️ c9 ♦️ n50 ♦️ true ♦️ cmd:log xbox boolean A true
# SINCO ♦️ note ♦️ c9 ♦️ n50 ♦️ false ♦️ cmd:log xbox boolean A false

# MPK mini play ♦️ note ♦️ c0 ♦️ n50 ♦️ true ♦️ cmd:log xbox boolean A true
# MPK mini play ♦️ note ♦️ c0 ♦️ n50 ♦️ false ♦️ cmd:log xbox boolean A false


# MPK mini play ♦️ control ♦️ 50 ♦️ 0-50 ♦️ cmd:log MPK Control 50 
# MPK mini play ♦️ control ♦️ 50 ♦️ 80-127 ♦️ cmd:log xbox boolean A false
