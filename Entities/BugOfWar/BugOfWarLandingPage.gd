extends Node

onready var music = MusicManager.get_child(0)

func _ready():
	MusicManager.play_track(2)
	music.connect("finished", self, "_on_Music_finished")


func _on_ClientButton_pressed():
	Global.goto_scene("res://Scripts/Controllers/ClientController.tscn")
	MusicManager.stop_music()


func _on_ServerButton_pressed():
	Global.goto_scene("res://Scripts/ServerGame.tscn")
#	Global.goto_scene("res://Entities/BugOfWar/BasicMap.tscn")


func _on_Music_finished():
	MusicManager.play_track(2)
