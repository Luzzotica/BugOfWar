extends Node2D

const CONTROLLER = "controller"
const UNIT = "unit"

export(PackedScene) var player_controller_scene

var player_controllers: Dictionary = {}
var my_player_controller: PlayerController

signal new_player(player_controller)

func _ready():
	NetworkManager.connect("player_connected", self, "_on_NetworkManager_PlayerConnected")
	NetworkManager.connect("player_disconnected", self, "_on_NetworkManager_PlayerDisconnected")
	NetworkManager.connect("state_connect", self, "_on_state_connect")


func create_controller(id: int, player_info: Dictionary) -> PlayerController:
	# Create a new controller
	print("Creating player controller for: ", id, player_info)
	var controller: PlayerController = player_controller_scene.instance()
	controller.name = str(id)
	controller.player_network_id = id
	add_child(controller)
	
	emit_signal("new_player", controller)
	player_controllers[id] = {CONTROLLER: controller}
	
	if not get_tree().is_network_server():
		my_player_controller = controller
	
	return controller


# Called on the client by the server to create the PlayerController
remote func remote_create_controller():
	var id = get_tree().get_network_unique_id()
	var controller = create_controller(id, NetworkManager.get_client_info())
	controller.setup_client()


func clear_data():
	for value in player_controllers.values():
		if CONTROLLER in value and value[CONTROLLER] != null:
			value[CONTROLLER].queue_free()
			value[CONTROLLER] = null
		if UNIT in value and value[UNIT] != null:
			value[UNIT].queue_free()
			value[UNIT] = null


func set_unit(controller: PlayerController, unit):
	player_controllers[controller.player_network_id][UNIT] = unit


# Used to avoid circular dependency between Unit and PlayerController
func controller_can_spawn_unit(controller: PlayerController):
	return (not UNIT in player_controllers[controller.player_network_id] or
		player_controllers[controller.player_network_id][UNIT] == null)


""" SIGNALS """


func _on_NetworkManager_PlayerConnected(id: int, player_info: Dictionary):
	var controller = create_controller(id, player_info)
	controller.setup_server(player_info)
	rpc_id(id, "remote_create_controller")


func _on_NetworkManager_PlayerDisconnected(id: int):
	# Delete the controller
	player_controllers[id][CONTROLLER].queue_free()
	if UNIT in player_controllers[id]:
		player_controllers[id][UNIT].queue_free()
	player_controllers.erase(id)


func _on_NetworkManager_game_start():
	# Make an ant
#	var a = ant.instance()
#	a.controller = controller
#	player_controllers[id][ANT] = a
#	add_child(a)
#	a.set_name_tag(player_info["name"])

	# Tell everyone that the game has started!
	pass


func _on_state_connect():
	clear_data()
