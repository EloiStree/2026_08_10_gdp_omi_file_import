class_name OmiFileTextToGodotKeyboardToCmd
extends  OmiFileTextAbstractGivenTextParser




signal on_unicode_integer_trigger_found(unicode_id:int, trigger_action:String)
signal on_unicode_integer_as_string_trigger_found(unicode_id:String, trigger_action:String)

signal on_unicode_char_trigger_found(unicode_char:String, trigger_action:String)

signal on_keyboard_key_enter_trigger_found(key_name:String, trigger_action:String)
signal on_keyboard_key_exit_trigger_found(key_name:String, trigger_action:String)



func _process_given_text_to_parse(text:String) -> void:

	for line in text.split(self.LINE_SPLITTER, false):
		if line.is_empty():
			continue
		var cells = line.split(self.DIAMOND_SPLITTER, false)

		if cells.size() ==2:
			var key_name = cells[0].strip_edges()
			var trigger_action = cells[1].strip_edges()
			if key_name.is_empty() or trigger_action.is_empty():
				continue
			
			on_keyboard_key_enter_trigger_found.emit(key_name, "bool:"+trigger_action+":true")
			on_keyboard_key_exit_trigger_found.emit(key_name, "bool:"+trigger_action+":false")

		if cells.size() < 3:
			continue

		var first_cell = cells[0].strip_edges().to_lower()
		if first_cell.is_empty():
			continue
		if first_cell == "unichar":
			var unicode_char = cells[1].strip_edges()
			var trigger_action = cells[2].strip_edges()
			on_unicode_char_trigger_found.emit(unicode_char, trigger_action)
		elif first_cell == "uniint":
			var unicode_int = int(cells[1].strip_edges())
			var trigger_action = cells[2].strip_edges()
			on_unicode_integer_trigger_found.emit(unicode_int, trigger_action)
			on_unicode_integer_as_string_trigger_found.emit(str(unicode_int), trigger_action)

		else:
			if cells[1].strip_edges().to_lower() == "in":
				var key_name = cells[0].strip_edges()
				var trigger_action = cells[2].strip_edges()
				on_keyboard_key_enter_trigger_found.emit(key_name, trigger_action)
			elif cells[1].strip_edges().to_lower() == "out":
				var key_name = cells[0].strip_edges()
				var trigger_action = cells[2].strip_edges()
				on_keyboard_key_exit_trigger_found.emit(key_name, trigger_action)
		
