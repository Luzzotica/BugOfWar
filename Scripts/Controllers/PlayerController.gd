class_name PlayerController
extends Node2D

var player_info: Dictionary
var direction: Vector2

signal action(info)


func setup_server(player_info: Dictionary):
	self.player_info = player_info


func setup_client():
	# If we are local, connect up the controller to our input manager for movement
	InputManager.connect("joystick_input", self, "_on_joystick_movement")
	InputManager.connect("action", self, "_on_action")


remote func set_direction(dir: Vector2):
	print("Moving: ", dir)
	direction = dir


remote func action(info):
	print("Client action: ", info)
	emit_signal("action", info)


func _on_joystick_movement(input: Vector2):
	rpc_unreliable_id(1, "set_direction", input)


func _on_action(info):
	rpc_id(1, "action", info)

