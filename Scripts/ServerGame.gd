extends Node

export(PackedScene) var game_to_load

enum ServerState { LOBBY, IN_GAME }

onready var lobby = $CanvasLayer/Control/ServerLobby
onready var game_ui = $CanvasLayer/Control/CenterContainer

var state = ServerState.LOBBY
var game

func _ready():
	NetworkManager.start_server()
	NetworkManager.connect("game_start", self, "_on_game_start")


func set_state(state):
	self.state = state
	hide_all()
	if state == ServerState.LOBBY:
		lobby.visible = true
		
	elif state == ServerState.IN_GAME:
		game_ui.visible = true
		build_game()


func build_game():
	if game != null:
		return
	game = game_to_load.instance()
	add_child(game)


func destroy_game():
	game.queue_free()
	game = null


func hide_all():
	lobby.visible = false
	game_ui.visible = false


""" SIGNALS """

func _on_Back_pressed():
	NetworkManager.end_connection()
	Global.goto_scene("res://Entities/BugOfWar/BugOfWarLandingPage.tscn")
	set_state(ServerState.LOBBY)


func _on_game_start():
	set_state(ServerState.IN_GAME)
