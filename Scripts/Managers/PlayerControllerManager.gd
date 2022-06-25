extends Node2D

const CONTROLLER = "controller"
const ANT = "ant"

export(PackedScene) var player_controller_scene
export(PackedScene) var ant

var player_controllers: Dictionary = {}

func _ready():
	NetworkManager.connect("player_connected", self, "_on_NetworkManager_PlayerConnected")
	NetworkManager.connect("player_disconnected", self, "_on_NetworkManager_PlayerDisconnected")
	NetworkManager.connect("state_connect", self, "_on_state_connect")


func create_controller(id: int, player_info: Dictionary) -> PlayerController:
	# Create a new controller
	print("Creating player controller for: ", id, player_info)
	var controller: PlayerController = player_controller_scene.instance()
	controller.name = str(id)
	add_child(controller)
	player_controllers[id] = { CONTROLLER: controller }
	return controller

# Called on the client by the server to create the PlayerController
remote func remote_create_controller():
	var id = get_tree().get_network_unique_id()
	var controller = create_controller(id, NetworkManager.get_client_info())
	controller.setup_client()


func clear_data():
	for value in player_controllers.values():
		if CONTROLLER in value:
			value[CONTROLLER].queue_free()
		if ANT in value:
			value[ANT].queue_free()


""" SIGNALS """

func _on_NetworkManager_PlayerConnected(id: int, player_info: Dictionary):
	var controller = create_controller(id, player_info)
	controller.setup_server(player_info)
	rpc_id(id, "remote_create_controller")
	
	# Make an ant
	var a = ant.instance()
	a.controller = controller
	player_controllers[id][ANT] = a
	add_child(a)
	a.set_name_tag(player_info["name"])


func _on_NetworkManager_PlayerDisconnected(id: int):
	# Delete the controller
	player_controllers[id][CONTROLLER].queue_free()
	player_controllers[id][ANT].queue_free()
	player_controllers.erase(id)


func _on_state_connect():
	clear_data()
