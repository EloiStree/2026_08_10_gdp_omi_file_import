class_name OMIFileMouseToCommand
extends Node


signal on_left_button_down_command(command:String)
signal on_left_button_up_command(command:String)
signal on_middle_button_down_command(command:String)
signal on_middle_button_up_command(command:String)
signal on_right_button_down_command(command:String)
signal on_right_button_up_command(command:String)

signal on_x1_button_down_command(command:String)
signal on_x1_button_up_command(command:String)
signal on_x2_button_down_command(command:String)
signal on_x2_button_up_command(command:String)

signal on_scroll_up_command(command:String)
signal on_scroll_down_command(command:String)
signal on_scroll_left_command(command:String)
signal on_scroll_right_command(command:String)


@export var _left_key_tag:Array[String] = ["left","l","1"]
@export var _middle_key_tag:Array[String] = ["middle","m","2"]
@export var _right_key_tag:Array[String] = ["right","r","3"]
@export var _x1_key_tag:Array[String] = ["side_button_1","x1","4"]
@export var _x2_key_tag:Array[String] = ["side_button_2","x2","x","5"]
@export var _scroll_up_key_tag:Array[String] = ["scroll_up","up","u"]
@export var _scroll_down_key_tag:Array[String] = ["scroll_down","down","d"]
@export var _scroll_left_key_tag:Array[String] = ["scroll_left","left","l"]
@export var _scroll_right_key_tag:Array[String] = ["scroll_right","right","r"]

func push_in_text_to_parse(text:String):
	var lines :PackedStringArray = text.split("\n")
	for line in lines:
		line = line.strip_edges()
		if line.begins_with("#"):
			continue
		if not line.is_empty():
			var parts:PackedStringArray = line.split("♦")
			print("############### ")
			print("line: ", line)
			print("parts: ", parts)
			var count:int = parts.size()
			if count==2:
					var type:String = parts[0].strip_edges().to_lower()
					var cmd:String = parts[1].strip_edges()
					if is_key_tag(_scroll_up_key_tag, type):
						on_scroll_up_command.emit(cmd)
					elif is_key_tag(_scroll_down_key_tag, type):
						on_scroll_down_command.emit(cmd)
					elif is_key_tag(_scroll_left_key_tag, type):
						on_scroll_left_command.emit(cmd)
					elif is_key_tag(_scroll_right_key_tag, type):
						on_scroll_right_command.emit(cmd)
			if count==3:


					# LEFT ♦️ true ♦️ cmd:log BUTTON_LEFT true
					# LEFT ♦️ false ♦️ cmd:log BUTTON_LEFT false
					# MIDDLE ♦️ true ♦️ cmd:log BUTTON_MIDDLE true
					# MIDDLE ♦️ false ♦️ cmd:log BUTTON_MIDDLE false
					# RIGHT ♦️ true ♦️ cmd:log BUTTON_RIGHT true
					# RIGHT ♦️ false ♦️ cmd:log BUTTON_RIGHT false

					var type:String = parts[0].strip_edges().to_lower()
					var cmd:String = parts[2].strip_edges()
					var type_true_false:String = parts[1].to_lower().strip_edges(true,true)
					type_true_false = type_true_false.replace(" ","").replace("\n","").replace("\t","")
					var is_true = type_true_false.contains("true")
					var is_false = type_true_false.contains("false")
					print("type|", type,"|")
					print("type_true_false|",type_true_false,"|")
					print("cmd|", cmd,"|")
					print("is_true|", is_true,"|")
					print("is_false|", is_false,"|")
					if is_true:
						if is_key_tag(_left_key_tag, type):
							print ("emit left button down command: ", cmd)
							on_left_button_down_command.emit(cmd)
						elif is_key_tag(_middle_key_tag, type):
							print ("emit middle button down command: ", cmd)
							on_middle_button_down_command.emit(cmd)
						elif is_key_tag(_right_key_tag, type):
							print ("emit right button down command: ", cmd)
							on_right_button_down_command.emit(cmd)
						elif is_key_tag(_x1_key_tag, type):
							print ("emit x1 button down command: ", cmd)
							on_x1_button_down_command.emit(cmd)
						elif is_key_tag(_x2_key_tag, type):
							print ("emit x2 button down command: ", cmd)
							on_x2_button_down_command.emit(cmd)
					if is_false:
						if is_key_tag(_left_key_tag, type):
							print ("emit left button up command: ", cmd)
							on_left_button_up_command.emit(cmd)
						elif is_key_tag(_middle_key_tag, type):
							print ("emit middle button up command: ", cmd)
							on_middle_button_up_command.emit(cmd)
						elif is_key_tag(_right_key_tag, type):
							print ("emit right button up command: ", cmd)
							on_right_button_up_command.emit(cmd)
						elif is_key_tag(_x1_key_tag, type):
							print ("emit x1 button up command: ", cmd)
							on_x1_button_up_command.emit(cmd)		
						elif is_key_tag(_x2_key_tag, type):
							print ("emit x2 button up command: ", cmd)
							on_x2_button_up_command.emit(cmd)

func is_key_tag(tag_array:Array[String], key:String) -> bool:
	for tag in tag_array:
		if tag.to_lower().strip_edges(true,true)==key.to_lower().strip_edges(true,true):
			return true
	return false

# FILE>>>|.mouse_to_command

# LEFT ♦️ true ♦️ cmd:log BUTTON_LEFT true
# LEFT ♦️ false ♦️ cmd:log BUTTON_LEFT false
# MIDDLE ♦️ true ♦️ cmd:log BUTTON_MIDDLE true
# MIDDLE ♦️ false ♦️ cmd:log BUTTON_MIDDLE false
# RIGHT ♦️ true ♦️ cmd:log BUTTON_RIGHT true
# RIGHT ♦️ false ♦️ cmd:log BUTTON_RIGHT false

# X1 ♦️ true ♦️ cmd:log BUTTON_X1 true
# X1 ♦️ false ♦️ cmd:log BUTTON_X1 false
# X2 ♦️ true ♦️ cmd:log BUTTON_X2 true
# X2 ♦️ false ♦️ cmd:log BUTTON_X2 false

# SCROLL_UP ♦️ cmd:log SCROLL_UP
# SCROLL_DOWN ♦️ cmd:log SCROLL_DOWN
# SCROLL_RIGHT ♦️ cmd:log SCROLL_RIGHT
# SCROLL_LEFT ♦️ cmd:log SCROLL_LEFT

# SCROLL_UP ♦️3♦️ cmd:log SCROLL_UP 3 time
# SCROLL_DOWN ♦️3♦️ cmd:log SCROLL_DOWN 3 time
