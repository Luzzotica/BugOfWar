extends Node2D

const PORT = 4567

var peer = NetworkedMultiplayerENet.new()

# Connect all functions

func _ready():
	get_tree().connect("network_peer_connected", self, "_network_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_network_peer_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	get_tree().connect("connection_failed", self, "_connection_failed")
	get_tree().connect("server_disconnected", self, "_server_disconnected")


""" CLIENT HANDLING """

var player_name = "Swagmaster"

func setup_client(player_name: String):
	self.player_name = player_name


func connect_to_server(ip: String):
	peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip, PORT)
	get_tree().network_peer = peer


func get_client_info() -> Dictionary:
	return {
		"name": player_name
	}


""" SERVER HANDLING """

const MAX_PLAYERS: int = 8

var players: Dictionary = {}

signal player_connected(id, player_info)
signal player_disconnected(id, player_info)

func start_server():
	print("Starting server")
	peer = NetworkedMultiplayerENet.new()
	peer.create_server(PORT, MAX_PLAYERS)
	get_tree().network_peer = peer


remote func player_joined(player_info: Dictionary):
	# Save the player info, and tell people about it
	var id = get_tree().get_rpc_sender_id()
	players[id] = player_info
	print("Received Player Info from: ", player_info)
	emit_signal("player_connected", id, player_info)


""" SHARED FUNCTIONS """

func end_connection():
	print("Ending connection")
	peer.close_connection()


""" SIGNAL HANDLING """

func _network_peer_connected(id):
	print("Person connected with id:", id)


func _network_peer_disconnected(id):
	if (not get_tree().is_network_server()):
		return
	
	print("Person disconnected with id:", id)
	assert(get_tree().is_network_server())
	if players.has(id):
		players.erase(id)
		emit_signal("player_disconnected", id)


func _connected_to_server():
	print("Connected to server")
	# Tell the server our info
	var id = get_tree().get_rpc_sender_id()
	var info: Dictionary = get_client_info()
	rpc_id(1, "player_joined", info)


func _connection_failed():
	pass # Could not even connect to server; abort.


func _server_disconnected():
	print("Server disconnected")
	pass # Server kicked us; show error and abort.


