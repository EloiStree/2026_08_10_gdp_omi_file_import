class_name OmiFileParseTextToScAlias
extends Node


#signal on_parsed_alias_for_shortcut_dictionary(alias_to_value:Dictionary[String,String])
signal on_parsed_alias_for_shortcut_one_by_one(alias:String, value:String)
signal on_parsed_alias_for_shortcut_one_by_one_with_description(alias:String, value:String, description:String)


func push_in_text_to_parse(text:String):
	var lines :PackedStringArray = text.split("\n")
	for line in lines:
		line = line.strip_edges()
		if line.begins_with("#"):
			continue
		if not line.is_empty():
			var parts:PackedStringArray = line.split("♦")
			if parts.size()>0:
				parts[0]=parts[0].strip_edges()
			if parts.size()>1:
				parts[1]=parts[1].strip_edges()
			if parts.size()>2:
				parts[2]=parts[2].strip_edges()
				
			if parts.size()>2:
				on_parsed_alias_for_shortcut_one_by_one.emit(parts[0],parts[1])
				on_parsed_alias_for_shortcut_one_by_one_with_description.emit(parts[0],parts[1],"")
			if parts.size()>3:
				on_parsed_alias_for_shortcut_one_by_one.emit(parts[0],parts[1])
				on_parsed_alias_for_shortcut_one_by_one_with_description.emit(parts[0],parts[1],parts[2])
	
			
		
	
	
	
