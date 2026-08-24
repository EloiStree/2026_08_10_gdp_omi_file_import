class_name OmiFileGateIn
extends Node

signal on_request_udp_listener_for_bytes(ip_address_mask:String, port:int)
signal on_request_udp_listener_for_text(ip_address_mask:String, port:int)
signal on_request_websocket_listener_as_server(ip_address_mask:String, port:int)
signal on_request_websocket_listener_as_client(ip_address_server:String, port:int)
signal on_request_folder_listener(folder_path:String)


@export var _use_debug_prints:bool = true
@export_multiline var _last_received_text:String = ""

func push_in_text_to_parse(text:String):
	text = text.to_lower()
	_last_received_text = text
	for line in text.split("\n"):
		line = line.strip_edges()
		if line.begins_with("#") or line == "":
			continue
		var parts = line.split("♦️")
		if parts.size() == 4:
			var line_type = parts[0].strip_edges()
			if line_type=="udp" :
				#udp♦️byte♦️0.0.0.0♦️2615
				#udp♦️text♦️0.0.0.0♦️2614
				var port_str = parts[3].strip_edges()
				if is_integer(port_str):
					var is_byte = parts[1].strip_edges() == "byte"
					var ip_address_mask = parts[2].strip_edges()
					var port = int(port_str)
					if is_byte:
						on_request_udp_listener_for_bytes.emit(ip_address_mask, port)
						if _use_debug_prints:
							print("UDP Byte Listener Requested:", ip_address_mask, ",", port)
					else:
						on_request_udp_listener_for_text.emit(ip_address_mask, port)
						if _use_debug_prints:
							print("UDP Text Listener Requested:", ip_address_mask, ",", port)
			elif line_type=="websocket":
				#websocket♦️server♦️0.0.0.0♦️2616
				#websocket♦️client♦️raspberrypi.local♦️73
				var port_str = parts[3].strip_edges()
				if is_integer(port_str):
					var is_server = parts[1].strip_edges() == "server"
					var ip_address_mask = parts[2].strip_edges()
					var port = int(port_str)
					if is_server:
						on_request_websocket_listener_as_server.emit(ip_address_mask, port)
						if _use_debug_prints:
							print("WebSocket Listener as Server Requested:", ip_address_mask, ",", port)
					else:
						on_request_websocket_listener_as_client.emit(ip_address_mask, port)
						if _use_debug_prints:
							print("WebSocket Listener as Client of server Requested:", ip_address_mask, ",", port)
		if parts.size() == 3:
			var line_type = parts[0].strip_edges()
			if line_type=="folder":
				#folder♦️5♦️user://data/config/drop_script
				#folder♦️5♦️res://data/config/drop_script
				var folder_refresh_seconds_timer_str = float(parts[1].strip_edges())
				var folder_path = parts[2].strip_edges()
				on_request_folder_listener.emit(folder_path)
				if _use_debug_prints:
					print("Folder Listener Requested:", folder_path, "Refresh Seconds:", folder_refresh_seconds_timer_str)



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


#FILE>>>|.gate_out_udp
### THE APP DONT SUPPORT YET SEVERAL SERVER.
#udp♦️byte♦️0.0.0.0♦️2615
#udp♦️text♦️0.0.0.0♦️2614
#websocket♦️server♦️0.0.0.0♦️2616
#websocket♦️client♦️raspberrypi.local♦️73
#folder♦️5♦️user://data/config/drop_script
#folder♦️5♦️res://data/config/drop_script
#
### TO DO ONE DAY
## Download the page and if the sha256 changed reload as input
## http♦️30s♦️https://github.com/EloiStree/IP/blob/main/IIDWS/SERVER.txt
### Reimport if the file changed or was creatd
## file♦️30s♦️file_path
### Read exising file in the folder and destroy them
### The aim is to use dropbox type of input.
## folder♦️30s♦️folder_path
