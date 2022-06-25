class_name PlayerController
extends Node2D

var player_info: Dictionary
var direction: Vector2
var grab_pressed: bool
var special_pressed: bool

signal action(info)


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
	emit_signal("action", info)


func _on_frame_input(input: Dictionary):
	rpc_unreliable_id(1, "set_input", input)


func _on_frame_input_local(input: Dictionary):
	direction = input["d"]
	grab_pressed = input["g"]
	special_pressed = input["s"]


func _on_reliable_action(info: Dictionary):
	rpc_id(1, "action", info)
