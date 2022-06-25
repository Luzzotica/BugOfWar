extends Node


func _on_ClientButton_pressed():
	Global.goto_scene("res://Scenes/ClientStartPage.tscn")


func _on_ServerButton_pressed():
	Global.goto_scene("res://Scenes/ServerStartPage.tscn")
