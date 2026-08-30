class_name OmiFileAbInputAnalogToS2w
extends Node


signal on_requested_ab_input_analog_to_motor(
	source_analog_name: String,
	source_analog_min_value: float,
	source_analog_max_value: float,
	destination_player_index: int,
	destination_motor_index: int
)

signal on_requested_ab_input_analog_to_joystick(
	source_analog_jlh_name: String,
	source_analog_jlv_name: String,
	source_analog_jrh_name: String,
	source_analog_jrv_name: String,
	source_analog_min_value: float,
	source_analog_max_value: float,
	destination_player_index: int
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
		if parts.size() < 5:
			continue
		for i in range(parts.size()):
			parts[i] = parts[i].strip_edges()
		var count = parts.size()
		if count == 5:
			if parts[0].is_valid_int() and \
				parts[1].is_valid_int() and \
				parts[2].is_valid_float() and \
				parts[3].is_valid_float() and \
				parts[4] != "":
				var destination_player_index = parts[0].to_int()
				var source_min_value = parts[1].to_float()
				var source_max_value = parts[2].to_float()
				var source_name = parts[3]
				var destination_motor_index = parts[4].to_int()
				on_requested_ab_input_analog_to_motor.emit(source_name,
				 source_min_value,
				 source_max_value,
				 destination_player_index,
				 destination_motor_index)

		if count==7:
			if parts[0].is_valid_int() and \
				parts[1].is_valid_float() and \
				parts[2].is_valid_float() and \
				parts[3] != "" and \
				parts[4] != "" and \
				parts[5] != "" and \
				parts[6] != "":
				var destination_player_index = parts[0].to_int()
				var source_min_value = parts[1].to_float()
				var source_max_value = parts[2].to_float()
				var source_jlh_name = parts[3]
				var source_jlv_name = parts[4]
				var source_jrh_name = parts[5]
				var source_jrv_name = parts[6]
				on_requested_ab_input_analog_to_joystick.emit(source_jlh_name, source_jlv_name, source_jrh_name, source_jrv_name, source_min_value, source_max_value, destination_player_index)



# FILE>>>|.ab_input_analog_to_s2w
# ## Gamepad 
# # Player id | min | max | jlh | jlv | jrh | jrv
# # 1♦️ 1.0 ♦️ -1.0 ♦️ jlh ♦️ jlv ♦️ jrh ♦️ jrv
# 1 ♦️ 1.0 ♦️ -1.0 ♦️ wingman_horizontal ♦️ wingman_vertical ♦️ wingman_twist ♦️ wingman_speed

# # Analog to motor
# # Motor Index | Player Index | Min | Max |  | Analog Name
# # Horizontal
#  0 ♦️ 1 ♦️ 0 ♦️  1.0 ♦️   xbox one s controller|s0|a0
#  1 ♦️ 1 ♦️ 0 ♦️  1.0 ♦️   xbox one s controller|s0|a0

# # Vertical
#  2 ♦️ 1 ♦️ 0 ♦️  1.0 ♦️   xbox one s controller|s0|a1
#  3 ♦️ 1 ♦️ 0 ♦️  1.0 ♦️   xbox one s controller|s0|a1

# # Horizontal
#  4 ♦️ 1 ♦️ 0 ♦️  1.0 ♦️   xbox one s controller|s0|a2
#  5 ♦️ 1 ♦️ 0 ♦️  1.0 ♦️   xbox one s controller|s0|a2
#  #Vertical
#  6 ♦️ 1 ♦️ 0 ♦️  1.0 ♦️   xbox one s controller|s0|a3
#  7 ♦️ 1 ♦️ 0 ♦️  1.0 ♦️   xbox one s controller|s0|a3

# # Left Trigger
#  8 ♦️ 1 ♦️ 0 ♦️  1.0 ♦️   xbox one s controller|s0|a4

# # Right Trigger
#  9 ♦️ 1 ♦️ 0 ♦️  1.0 ♦️   xbox one s controller|s0|a5
