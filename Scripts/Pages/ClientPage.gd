extends Node

onready var setup: Control = $Setup
onready var lobby: Control = $Lobby
onready var controllerUI: Control = $Controller

onready var lobbyReady: CheckButton = $Lobby/ReadyToRumble

onready var inputName: LineEdit = $Setup/CenterContainer/Name
onready var inputIp: LineEdit = $Setup/CenterContainer/IP

var grab_pressed = false
var special_pressed = false
var lobby_ready = false

func _ready():
	NetworkManager.connect("lobby", self, "_on_lobby")
	NetworkManager.connect("game_start", self, "_on_game_start")


func _process(delta):
	if grab_pressed:
		InputManager.unreliable_action("grab")
	if special_pressed:
		InputManager.unreliable_action("special")


func _on_lobby():
	setup.visible = false
	lobby.visible = true
	controllerUI.visible = false


func _on_game_start():
	setup.visible = false
	lobby.visible = false
	controllerUI.visible = true


func _on_Connect_pressed():
	NetworkManager.setup_client(inputName.text)
	NetworkManager.connect_to_server(inputIp.text)


func _on_Back_pressed():
	NetworkManager.end_connection()
	Global.goto_scene("res://Scenes/LandingPage.tscn")


func _on_Grab_button_down():
	grab_pressed = true


func _on_Grab_button_up():
	grab_pressed = false


func _on_Special_button_down():
	special_pressed = true


func _on_Special_button_up():
	special_pressed = false


func _on_ReadyToRumble_pressed():
	lobby_ready = not lobby_ready
	print(lobby_ready)
	NetworkManager.rpc_id(1, "set_player_ready", lobby_ready)
