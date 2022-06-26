extends Node

export(PackedScene) var bug_of_war_controller
export(PackedScene) var team_selection_button

onready var home: Control = $CanvasLayer/Home
onready var lobby: Control = $CanvasLayer/Lobby
onready var controller_container: Control = $CanvasLayer/ControllerHolder

onready var lobbyReady: Button = $CanvasLayer/Lobby/ReadyToRumble

onready var inputName: LineEdit = $CanvasLayer/Home/CenterContainer/Name
onready var inputIp: LineEdit = $CanvasLayer/Home/CenterContainer/IP

enum ControllerState { HOME, LOBBY, CONTROLLER }
enum ControllerType { BUG_OF_WAR }

var controller_state = ControllerState.HOME
var lobby_ready = false

var controller_type = ControllerType.BUG_OF_WAR
var virtual_controller = null


func _ready():
	NetworkManager.connect("state_connect", self, "_on_state_connect")
	NetworkManager.connect("lobby", self, "_on_lobby")
	NetworkManager.connect("game_start", self, "_on_game_start")


func set_controller_state(state):
	controller_state = state
	hide_everything()
	if controller_state == ControllerState.HOME:
		destory_virtual_controller()
		home.visible = true
	elif controller_state == ControllerState.LOBBY:
		destory_virtual_controller()
		lobby.visible = true
	elif controller_state == ControllerState.CONTROLLER:
		build_virtual_controller()
		controller_container.visible = true


func build_virtual_controller():
	if controller_type == ControllerType.BUG_OF_WAR:
		virtual_controller = bug_of_war_controller.instance()
		controller_container.add_child(virtual_controller)
		# Wire up the controller states
		PlayerControllerManager.my_player_controller.connect("change_controller_state", virtual_controller, "_on_player_controller_state_change")
		


func destory_virtual_controller():
	if virtual_controller != null:
		virtual_controller.queue_free()
		virtual_controller = null


func hide_everything():
	home.visible = false
	lobby.visible = false
	controller_container.visible = false


""" SIGNALS """

func _on_state_connect():
	set_controller_state(ControllerState.HOME)
	lobby_ready = false


func _on_lobby(team_count: int):
	set_controller_state(ControllerState.LOBBY)


func _on_game_start():
	set_controller_state(ControllerState.CONTROLLER)


func _on_Connect_pressed():
	NetworkManager.setup_client(inputName.text)
	NetworkManager.connect_to_server(inputIp.text)


func _on_Back_pressed():
	NetworkManager.end_connection()
	Global.goto_scene("res://Entities/BugOfWar/BugOfWarLandingPage.tscn")


func _on_ReadyToRumble_pressed():
	lobby_ready = not lobby_ready
	PlayerControllerManager.my_player_controller.set_ready(lobby_ready)


func _on_Team1_pressed():
	PlayerControllerManager.my_player_controller.set_team(1)


func _on_Team2_pressed():
	PlayerControllerManager.my_player_controller.set_team(2)
