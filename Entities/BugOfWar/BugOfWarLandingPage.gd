extends Node


func _on_ClientButton_pressed():
	Global.goto_scene("res://Scripts/Controllers/ClientController.tscn")


func _on_ServerButton_pressed():
	Global.goto_scene("res://Scripts/ServerGame.tscn")
#	Global.goto_scene("res://Entities/BugOfWar/BasicMap.tscn")
