extends Node2D

export(PackedScene) var player_controller_scene

var player_controllers: Dictionary = {}

func _ready():
	NetworkManager.connect("player_connected", self, "_on_NetworkManager_PlayerConnected")
	NetworkManager.connect("player_disconnected", self, "_on_NetworkManager_PlayerDisconnected")


func create_controller(id: int, player_info: Dictionary) -> PlayerController:
	# Create a new controller
	print("Creating player controller for: ", id, player_info)
	var controller: PlayerController = player_controller_scene.instance()
	controller.name = str(id)
	add_child(controller)
	player_controllers[id] = controller
	return controller

# Called on the client by the server to create the PlayerController
remote func remote_create_controller():
	var id = get_tree().get_network_unique_id()
	var controller = create_controller(id, NetworkManager.get_client_info())
	controller.setup_client()


""" SIGNALS """

func _on_NetworkManager_PlayerConnected(id: int, player_info: Dictionary):
	var controller = create_controller(id, player_info)
	controller.setup_server(player_info)
	rpc_id(id, "remote_create_controller")


func _on_NetworkManager_PlayerDisconnected(id: int):
	# Delete the controller
	player_controllers[id].queue_free()
	player_controllers.erase(id)
