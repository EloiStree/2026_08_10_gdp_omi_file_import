class_name OmiFileTextAbstractGivenTextParser
extends Node


const LINE_SPLITTER:String = "\n"
const DIAMOND_SPLITTER:String = "♦️"

signal on_start_parsing()
signal on_received_text_to_parse(text:String)
signal on_end_parsing()


func _notify_start_parsing() -> void:
	on_start_parsing.emit()

func _notify_received_text_to_parse(text:String) -> void:
	on_received_text_to_parse.emit(text)

func _notify_end_parsing() -> void:
	on_end_parsing.emit()


func push_in_text_to_parse(text:String) -> void:
	_notify_received_text_to_parse(text)
	_notify_start_parsing()
	_process_given_text_to_parse(text)
	_notify_end_parsing()

func _process_given_text_to_parse(text:String) -> void:
	pass
