extends Node2D

const PORT = 4567

# Connect all functions

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")


""" CLIENT HANDLING """

var player_name = "Swagmaster"

func setup_client(player_name: String):
	self.player_name = player_name


func connect_to_server(ip: String):
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip, PORT)
	get_tree().network_peer = peer


func get_client_info() -> Dictionary:
	return {
		"name": player_name
	}


""" SERVER HANDLING """

var players: Dictionary = {}

signal player_connected(id, player_info)
signal player_disconnected(id, player_info)

remote func player_joined(player_info: Dictionary):
	# Save the player info, and tell people about it
	var id = get_tree().get_rpc_sender_id()
	players[id] = player_info
	emit_signal("player_connected", id, player_info)


""" SIGNAL HANDLING """

func _network_peer_connected(id):
	print("Person connected with id:", id)


func _network_peer_disconnected(id):
	print("Person disconnected with id:", id)
	assert(get_tree().is_network_server())
	if players.has(id):
		players.erase(id)
		emit_signal("player_disconnected", id)


func _connected_to_server():
	print("Connected to server")
	# Tell the server our info
	rpc_id(1, "player_joined", get_client_info())


func _connection_failed():
	pass # Could not even connect to server; abort.


func _server_disconnected():
	pass # Server kicked us; show error and abort.


