class_name OmiFileNtpServers
extends Node

signal on_request_to_connect_at_ntp_server(address_found:String )
signal on_request_to_connect_at_ntp_servers(addresses_found:Array[String])

func push_in_text_to_parse(text:String):
    if text.is_empty():
        return

    if text.begins_with("#"):
        return

    var server_addresses:Array[String] = []
    var lines :PackedStringArray = text.split("\n")
    for line in lines:
        line = line.strip_edges()
        if line.begins_with("#"):
            continue
        if line.begins_with("📕"):
            continue
        if len(line) <= 5:
            continue
        server_addresses.append(line)

    if server_addresses.size() > 0:
        on_request_to_connect_at_ntp_servers.emit(server_addresses)
        for address in server_addresses:
            on_request_to_connect_at_ntp_server.emit(address)




 