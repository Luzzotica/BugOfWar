extends Node

var players: Array = []

# Player info, associate ID to data
#var player_info = {} 
# Info we send to other players
#var my_info = { name = "Johnson Magenta", favorite_color = Color8(255, 0, 255) }

signal player_connected(id)
signal player_disconnected(id)

# Connect all functions

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")


func _network_peer_connected(id):
	# Called on both clients and server when a peer connects. Send my info to it.
#	rpc_id(id, "register_player", my_info)
	pass


func _network_peer_disconnected(id):
#	player_info.erase(id) # Erase player from info.
	pass


func _connected_to_server():
	pass # Only called on clients, not server. Will go unused; not useful here.


func _connection_failed():
	pass # Could not even connect to server; abort.


func _server_disconnected():
	pass # Server kicked us; show error and abort.


remote func register_player(info):
	# Get the id of the RPC sender.
	var id = get_tree().get_rpc_sender_id()
	# Store the info
	player_info[id] = info

	# Call function to update lobby UI here


