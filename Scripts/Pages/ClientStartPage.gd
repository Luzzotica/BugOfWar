extends Node

onready var inputName: LineEdit = $CenterContainer/Name
onready var inputIp: LineEdit = $CenterContainer/IP


func _on_Connect_pressed():
	NetworkManager.setup_client(inputName.text)
	NetworkManager.connect_to_server(inputIp.text)


func _on_Back_pressed():
	NetworkManager.end_connection()
	Global.goto_scene("res://Scenes/LandingPage.tscn")
