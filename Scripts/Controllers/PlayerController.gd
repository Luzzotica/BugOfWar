class_name PlayerController
extends Node2D

var player_network_id: int
var player_info: Dictionary

var team: int = 0
var lobby_ready: bool = false

# Input
var direction: Vector2
var grab_pressed: bool
var special_pressed: bool

signal action(player, info)
signal team_changed(player, team)
signal lobby_ready(player, ready)
signal change_controller_state(state)

func setup_server(player_info: Dictionary):
	self.player_info = player_info


func setup_client():
	# If we are local, connect up the controller to our input manager for movement
	InputManager.connect("frame_input", self, "_on_frame_input")
	InputManager.connect("reliable_action", self, "_on_reliable_action")


func setup_local():
	InputManager.connect("frame_input", self, "_on_frame_input_local")


remote func set_input(input: Dictionary):
#	print("Moving: ", dir)
	direction = input["d"]
	grab_pressed = input["g"]
	special_pressed = input["s"]


remote func action(info: Dictionary):
	print('received action: ', info)
	emit_signal("action", self, info)


remote func set_team(team: int):
	self.team = team
	emit_signal("team_changed", self, team)
	
	# Tell the server
	if not get_tree().is_network_server():
		
		rpc_id(1, "set_team", team)


remote func set_ready(ready: bool):
	lobby_ready = ready
	emit_signal("lobby_ready", self, ready)
	
	# Tell the server
	if not get_tree().is_network_server():
		rpc_id(1, "set_ready", ready)


# Called on the client to set the state of a game controller
remote func set_controller_state(state: int):
	print("changing controller state")
	emit_signal("change_controller_state", state)


func _on_frame_input(input: Dictionary):
	rpc_unreliable_id(1, "set_input", input)


func _on_frame_input_local(input: Dictionary):
	direction = input["d"]
	grab_pressed = input["g"]
	special_pressed = input["s"]


func _on_reliable_action(info: Dictionary):
	print('Sending action to server')
	rpc_id(1, "action", info)


func _on_owned_unit_died():
	rpc_id(player_network_id, "set_controller_state", 2)
