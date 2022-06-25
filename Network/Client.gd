extends Node

var player_name = "Swagmaster"

signal player_connected(id)
signal player_disconnected(id)

# Connect all functions

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")


func setup(player_name: String):
	var player_info = {
		"name": player_name
	}
	self.player_name = player_name


func connect_to_server(ip: String, port: String):
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip, port)
	get_tree().network_peer = peer


func _network_peer_connected(id):
	# Called on both clients and server when a peer connects. Send my info to it.
#	rpc_id(id, "register_player", my_info)
	pass


func _network_peer_disconnected(id):
#	player_info.erase(id) # Erase player from info.
	pass


func _connected_to_server():
	rpc_id(1, 
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


