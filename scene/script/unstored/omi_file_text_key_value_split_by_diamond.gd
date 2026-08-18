class_name OmiFileTextKeyValueSplitByDiamond
extends OmiFileTextAbstractGivenTextParser

signal on_text_key_value_found(key:String, value:String)

func _process_given_text_to_parse(text:String) -> void:
	var lines = text.split(self.LINE_SPLITTER, false)
	for line in lines:
		line = line.strip_edges()
		if line.is_empty():
			continue
		if line.starts_with("#"):
			continue
		var key_value = line.split(self.DIAMOND_SPLITTER, false)
		if key_value.size() == 2:
			var key = key_value[0].strip_edges()
			var value = key_value[1].strip_edges()
			if key.empty():
				continue
			on_text_key_value_found.emit(key, value)
