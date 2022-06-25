extends Node2D

export(PackedScene) var worker_ant
export(Color) var color

onready var spawn_point: Node2D = $SpawnPoint

func _ready():
	self_modulate = color


func spawn_ant(controller: PlayerController, type: String):
	print(PlayerControllerManager.controller_can_spawn_unit(controller))
	print(type == Constants.BUG_OF_WAR_COMMAND_SPAWN_WORKER_ANT)
	if PlayerControllerManager.controller_can_spawn_unit(controller):
		if type == Constants.BUG_OF_WAR_COMMAND_SPAWN_WORKER_ANT:
			var ant = worker_ant.instance()
			add_child(ant)
			PlayerControllerManager.set_unit(controller, ant)
			ant.controller = controller
			ant.global_position = spawn_point.global_position
			ant.set_color(color)
			
			# Tell the player to update the controller state
			controller.rpc_id(controller.player_network_id, "set_controller_state", 0)
