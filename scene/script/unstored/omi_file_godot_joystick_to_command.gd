class_name OmiFileGodotJoystickToCommand
extends Node



signal on_request_duplicate_input_with_new_name(old_name:String, new_name:String)
signal on_request_rename_input_with_new_name(old_name:String, new_name:String)
signal on_request_append_xbox_if_has_text_in_name(text_to_have_to_be_xbox:String)

# TO DO LATER USE AB INPUT FOR NOW
signal on_request_command_for_boolean(device_name:String,spawn_index:int,button_index:int,state_to_trigger:bool,command:String)
# Xbox♦️1♦️bool♦️0♦️false♦️cmd:log Hello

# TO DO LATER USE AB INPUT FOR NOW
signal on_request_command_for_range(device_name:String,spawn_index:int,analog_index:int,min_value:float,max_value:float,trigger_when_in_range:bool,command:String)
# Xbox One S Controller♦️1♦️analog♦️0♦️-1.0♦️-0.8♦️in/out♦️ cmd:bool:left:true


@export var _use_debug_print:bool = false

func push_in_text_to_parse(text:String):
	var lines :PackedStringArray = text.split("\n")
	for line in lines:
		line = line.strip_edges()
		if line.begins_with("#"):
			continue
		if not line.is_empty():
			var parts:PackedStringArray = line.split("♦️")
			for i in range(parts.size()):
				parts[i] = parts[i].strip_edges()
			var count:int = parts.size()
			if count<2:
				continue

			if count==2 and parts[0] == "is_xbox":
				on_request_append_xbox_if_has_text_in_name.emit(parts[1].to_lower())
				if _use_debug_print:
					print("IS Xbox if containing:", parts[1].to_lower())
			elif count==3 and parts[0] == "duplicate":
				on_request_duplicate_input_with_new_name.emit(parts[1].to_lower(), parts[2].to_lower())
				if _use_debug_print:
					print("Duplicate name:", parts[1].to_lower()," To ", parts[2].to_lower())
			elif count==3 and parts[0] == "rename":
				on_request_rename_input_with_new_name.emit(parts[1].to_lower(), parts[2].to_lower())
				if _use_debug_print:
					print("Rename name:", parts[1].to_lower()," To ", parts[2].to_lower())

			elif count==6 and parts[2] == "bool":
			   # Xbox♦️1♦️bool♦️0♦️false♦️cmd:log Hello
				var device_name:String = parts[0].to_lower()
				var spawn_index:int = int(parts[1])
				var button_index:int = int(parts[3])
				var state_to_trigger:bool = parts[4]== "true"
				var command:String = parts[5]
				on_request_command_for_boolean.emit(device_name, spawn_index, button_index, state_to_trigger, command)
				if _use_debug_print:
					print("Parsed boolean command:"," | ".join([device_name, str(spawn_index), str(button_index), str(state_to_trigger), command]))
			elif count==8 and parts[2] == "analog" and (parts[6]== "in" or  parts[6]== "out"):
				# Xbox One S Controller♦️1♦️analog♦️0♦️-1.0♦️-0.8♦️in/out♦️ cmd:bool:left:true
				var device_name:String = parts[0].to_lower()
				var spawn_index:int = int(parts[1])
				var analog_index:int = int(parts[3])
				var min_value:float = float(parts[4])
				var max_value:float = float(parts[5])
				var trigger_when_in_range:bool =  parts[6]== "in"
				var command:String = parts[7]
				on_request_command_for_range.emit(device_name, spawn_index, analog_index, min_value, max_value, trigger_when_in_range, command)
				if _use_debug_print:
					print("Parsed range command:"," | ".join([device_name, str(spawn_index), str(analog_index), str(min_value), str(max_value), str(trigger_when_in_range), command]))




# FILE>>>|.joystick_to_command
# ## Listen to button
# Xbox One S Controller♦️bool♦️0♦️true♦️cmd:log Hello
# Xbox One S Controller♦️bool♦️0♦️false♦️cmd:log Hello

# ## Listen to button of the seconds xbox device found
# Xbox♦️1♦️bool♦️0♦️true♦️cmd:log Hello
# Xbox♦️1♦️bool♦️0♦️false♦️cmd:log Hello

# ## Joystick to Arrow
# Xbox One S Controller♦️1♦️analog♦️0♦️-1.0♦️-0.8♦️true♦️ cmd:bool:left:true
# Xbox One S Controller♦️1♦️analog♦️0♦️-1.0♦️-0.8♦️false♦️cmd:bool:left:false
# Xbox One S Controller♦️1♦️analog♦️0♦️0.8♦️1.0♦️true♦️ cmd:bool:right:true
# Xbox One S Controller♦️1♦️analog♦️0♦️0.8♦️1.0♦️false♦️cmd:bool:right:false
# Xbox One S Controller♦️1♦️analog♦️1♦️-1.0♦️-0.8♦️true♦️ cmd:bool:up:true
# Xbox One S Controller♦️1♦️analog♦️1♦️-1.0♦️-0.8♦️false♦️cmd:bool:up:false
# Xbox One S Controller♦️1♦️analog♦️1♦️0.8♦️1.0♦️true♦️ cmd:bool:down:true
# Xbox One S Controller♦️1♦️analog♦️1♦️0.8♦️1.0♦️false♦️cmd:bool:down:false

# Xbox One S Controller♦️1♦️analog♦️2♦️-1.0♦️-0.8♦️true♦️sc:ok
# Xbox One S Controller♦️1♦️analog♦️2♦️0.8♦️1.0♦️true♦️sc:cancel



# ## Listen to the thrid device found. (2)
# Xbox One S Controller♦️2♦️analog♦️0♦️-1.0♦️-0.8♦️true♦️ cmd:bool:left:true
# Xbox One S Controller♦️2♦️analog♦️0♦️-1.0♦️-0.8♦️false♦️cmd:bool:left:false



# duplicate♦️Xbox One S Controller♦️gamepad
# rename♦️Xbox One S Controller♦️xbox
# is_xbox♦️Xbox One S
