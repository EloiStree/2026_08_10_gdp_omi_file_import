class_name OmiFileGateOutUdp
extends Node

signal on_request_udp_pusher_for_bytes(ip_address_target:String, port:int)
signal on_request_udp_pusher_for_text(ip_address_target:String, port:int)

signal on_request_alias_udp_pusher_for_bytes(alias:String, ip_address_target:String, port:int)
signal on_request_alias_udp_pusher_for_text(alias:String, ip_address_target:String, port:int)


@export var _use_debug_prints:bool = false
@export_multiline var _last_received_text:String = ""

	
func push_in_text_to_parse(text:String):
	text = text.to_lower()
	_last_received_text = text
	for line in text.split("\n"):
		line = line.strip_edges()
		if line.begins_with("#") or line == "":
			continue
		var parts = line.split("♦️")
		if parts.size() == 3:
			var line_type = parts[0].strip_edges()
			if line_type=="byte" or line_type=="text":
				if line_type == "byte":
					var ip_address_target = parts[1].strip_edges()
					var parts_port = parts[2].strip_edges().split(" ")
					for port_str in parts_port:
						if not port_str.is_empty() and is_integer(port_str):
							var port = int(port_str)
							on_request_udp_pusher_for_bytes.emit(ip_address_target, port)
							if _use_debug_prints:
								print("UDP Byte Pusher Requested:", ip_address_target, ",", port)
				elif line_type == "text":
					var ip_address_target = parts[1].strip_edges()
					var parts_port = parts[2].strip_edges().split(" ")
					for port_str in parts_port:
						if not port_str.is_empty() and is_integer(port_str):
							var port = int(port_str)
							on_request_udp_pusher_for_text.emit(ip_address_target, port)
							if _use_debug_prints:
								print("UDP Text Pusher Requested:", ip_address_target, ",", port)

		if parts.size() == 4:
			var line_type = parts[1].strip_edges()
			var line_name = parts[0].strip_edges()
			if line_type=="byte" or line_type=="text":
				var ip_address_target = parts[2].strip_edges()
				var ports_str = parts[3].strip_edges().split(" ")
				for port_str in ports_str:
					if not port_str.is_empty() and is_integer(port_str):
						var port = int(port_str)
						if line_type == "byte":
							on_request_alias_udp_pusher_for_bytes.emit(line_name, ip_address_target, port)
							if _use_debug_prints:
								print("UDP Alias Byte Pusher Requested:", ip_address_target, ",", port, "Alias Name:", line_name )
						elif line_type == "text":
							on_request_alias_udp_pusher_for_text.emit(line_name, ip_address_target, port)
							if _use_debug_prints:
								print("UDP Alias Text Pusher Requested:", ip_address_target, ",", port, "Alias Name:", line_name )



const DIGIT_CHARS = "0123456789"
func is_digit(text:String) -> bool:
	for char in DIGIT_CHARS:
		if char == text:
			return true
	return false

func is_integer(text:String) -> bool:
	for char in text:
		if not is_digit(char):
			return false
	return true



# FILE>>>|.gate_out_udp
# byte♦️127.0.0.1♦️3615
# text♦️127.0.0.1♦️3614
# byte♦️192.168.178.49♦️3615
# text♦️192.168.178.49♦️3614
# byte♦️192.168.178.49♦️7073

# steam_machine♦️byte♦️192.168.178.49♦️7073
# steam_machine♦️byte♦️192.168.178.49♦️7072
# steam_machine♦️byte♦️192.168.178.49♦️7071
# steam_machine♦️byte♦️192.168.178.49♦️7070
# steam_machine♦️byte♦️192.168.178.49♦️3615
# steam_machine♦️text♦️192.168.178.49♦️3614
# paul♦️byte♦️192.168.178.49♦️ 7070 7071 7072 7073
