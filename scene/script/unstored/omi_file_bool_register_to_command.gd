class_name OmiFileBoolRegisterToCommand
extends Node

signal on_request_boolean_set_command(boolean_name:String, default_value:bool)
signal on_request_append_command_for_key_on_true(key:String, command:String)
signal on_request_append_command_for_key_on_false(key:String, command:String)
signal on_request_append_key_value_command(key:String, value:bool, command:String)

func push_in_text_to_parse(text:String):
	var lines :PackedStringArray = text.split("\n")
	for line in lines:
		line = line.strip_edges()
		if line.begins_with("#"):
			continue
		if not line.is_empty():
			var parts:PackedStringArray = line.split("♦")
			var count:int = parts.size()
			var key:String = parts[0].strip_edges().to_lower()
			var value_str:String = parts[1].strip_edges().to_lower()
			value_str = value_str.replace(" ","").replace("\n","").replace("\t","")
			var value_bool:bool = value_str.contains("true")
			if count==2:
				on_request_boolean_set_command.emit(key, value_bool)
				#print (">>BOOL>>> key: ", key, " value: ", value_bool)
			elif count==3:
				var command:String = parts[2].strip_edges()
				if value_bool:
					on_request_append_command_for_key_on_true.emit(key, command)
				else:
					on_request_append_command_for_key_on_false.emit(key, command)
				on_request_append_key_value_command.emit(key, value_bool, command)
				#print(">>BOOL CMD>>> key|", key, "| value|", value_bool, "| command|", command)




# FILE>>>|.bool_register_to_command

# xbox_a ♦️ false
# xbox_b ♦️ false
# xbox_x ♦️ false
# xbox_y ♦️ false

# xbox_a ♦️ true ♦️ cmd:log xbox boolean A
# xbox_a ♦️ false ♦️ cmd:log xbox boolean A

# xbox_b ♦️ true ♦️ cmd:log xbox boolean B
# xbox_b ♦️ false ♦️ cmd:log xbox boolean B

# xbox_x ♦️ true ♦️ cmd:log xbox boolean X
# xbox_x ♦️ false ♦️ cmd:log xbox boolean X

# xbox_y ♦️ true ♦️ cmd:log xbox boolean Y
# xbox_y ♦️ false ♦️ cmd:log xbox boolean Y
