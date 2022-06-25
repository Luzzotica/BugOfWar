extends Node


func _ready():
	NetworkManager.start_server()


func _on_Back_pressed():
	NetworkManager.end_connection()
	Global.goto_scene("res://Entities/BugOfWar/BugOfWarLandingPage.tscn")
