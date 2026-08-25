class_name OmiFileGodotEventToCommand
extends OmiFileTextAbstractGivenTextParser

signal on_at_ready_command_found(command:String)
signal on_at_focus_entered_command_found(command:String)
signal on_at_focus_exited_command_found(command:String)
signal on_at_exit_command_found(command:String)

func push_in_text_to_parse(text:String):
	var lines :PackedStringArray = text.split("\n")
	for line in lines:
		line = line.strip_edges()
		if line.begins_with("#"):
			continue
		var spares :PackedStringArray = line.split("♦️")
		if spares.size() == 2:
			var type_command :String = spares[0].strip_edges()
			var command :String = spares[1].strip_edges()
			if type_command == "at_ready":
				on_at_ready_command_found.emit(command)
			elif type_command == "at_focus_entered":
				on_at_focus_entered_command_found.emit(command)
			elif type_command == "at_focus_exited":
				on_at_focus_exited_command_found.emit(command)
			elif type_command == "at_exit":
				on_at_exit_command_found.emit(command)
