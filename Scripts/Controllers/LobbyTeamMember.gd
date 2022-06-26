extends Control

onready var name_tag: Label = $HBoxContainer/Label
onready var ready_text: Label = $HBoxContainer/Label2

var ready = false


func set_name(_name: String):
	name_tag.text = _name


func set_ready(ready: bool):
	if ready:
		ready_text.text = "Ready"
	else:
		ready_text.text = "Not Ready"
