class_name OmiFileAbInputToCommand
extends Node



signal on_request_ab_input_event_action(device_name:String, trigger_event:String, action:String)
signal on_request_ab_input_range_in_out_action(input_name:String, value_min:float, value_max:float, in_range:bool, action:String)
signal on_request_ab_input_boolean_action(input_name:String, value:bool, action:String)


@export var _use_debug_print:bool = false

func push_in_text_to_parse(text:String):
	var lines :PackedStringArray = text.split("\n")
	for line in lines:
		line = line.strip_edges()
		if line.begins_with("#"):
			continue
		if not line.is_empty():
			var parts:PackedStringArray = line.split("♦️")
			var count:int = parts.size()
			var key:String = parts[0].strip_edges().to_lower()
			if count<3:
				continue

			var raw_parts:Array[String] = []
			for part in parts:
				raw_parts.append(part+"")

			## remove spaces and newlines from value string
			## 0 to  parts.size()-1
			for i in range( count-1):
				parts[i] = parts[i].strip_edges().to_lower()
				parts[i] = parts[i].replace("\n","").replace("\t","")
			##All to lower except last part which is the action command
			for i in range( count-2):
				parts[i] = parts[i].to_lower()
			#print("?".join(parts))
			if count==3:
				var value_bool:bool = parts[1] == "true"
				var action:String = parts[2]
				on_request_ab_input_boolean_action.emit(key, value_bool, action)
				if _use_debug_print:
					print (">>AB BOOL>>> key: ", key, " value: ", value_bool, " action: ", action)

			elif count==4:
				if parts[1].begins_with("trigger"):
					var trigger_event:String = raw_parts[2].strip_edges()
					var action:String = parts[3]
					on_request_ab_input_event_action.emit(key,trigger_event,action)
					if _use_debug_print:
						print (">>AB EVENT>>> device_name: ", key, " trigger_event: ", trigger_event, " action: ", action)
			
			elif count==5:
				if parts[1].begins_with("in") or parts[1].begins_with("out"):
					var value_min:float = float(parts[2])
					var value_max:float = float(parts[3])
					var in_range:bool = parts[1].contains("in")
					var action:String = parts[4]
					on_request_ab_input_range_in_out_action.emit(key, value_min, value_max, in_range, action)
					if _use_debug_print:
						print (">>AB RANGE>>> input_name: ", key, " value_min: ", value_min, " value_max: ", value_max, " in_range: ", in_range, " action: ", action)



# godot_mouse ♦️ trigger♦️ MOUSE_SCROLL_UP ♦️ cmd:bool:xbox_a:true

# Xbox One S Controller|S0|B0 ♦️ true ♦️ cmd:bool:xbox_a:true
# Xbox One S Controller|S0|B0 ♦️ false ♦️ cmd:bool:xbox_a:false


# mpk mini play|bn|0|0|48 ♦️ true ♦️ cmd:bool:left_mkp:true
# mpk mini play|an|0|0|48 ♦️ false ♦️ cmd:bool:left_mkp:false
# mpk mini play|an|0|0|72 ♦️ in ♦️ 80 ♦️ 127 ♦️ cmd:bool:right_mkp_strong:true
# mpk mini play|an|0|0|72 ♦️ out ♦️ 80 ♦️ 127 ♦️ cmd:bool:right_mkp_strong:false
# mpk mini play|an|0|0|72 ♦️ in ♦️ 1 ♦️80 ♦️  cmd:bool:right_mkp_light:true
# mpk mini play|an|0|0|72 ♦️ out ♦️ 1 ♦️80 ♦️  cmd:bool:right_mkp_light:false
