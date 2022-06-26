extends Node

func _ready():
	MusicManager.play_track(2)

func _on_ClientButton_pressed():
	Global.goto_scene("res://Scripts/Controllers/ClientController.tscn")
	MusicManager.stop_music()


func _on_ServerButton_pressed():
	Global.goto_scene("res://Scripts/ServerGame.tscn")
#	Global.goto_scene("res://Entities/BugOfWar/BasicMap.tscn")
