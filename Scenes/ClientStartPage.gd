extends Node

onready var inputName: TextEdit = $CenterContainer/Name
onready var inputIp: TextEdit = $CenterContainer/IP


func go_to_scene(path: String):
	Global.goto_scene(path)


func _on_Connect_pressed():
	NetworkManager.setup_client(inputName.text)
	NetworkManager.connect_to_server(inputIp.text)
