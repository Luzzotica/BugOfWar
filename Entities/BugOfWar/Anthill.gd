extends Node2D

export(PackedScene) var worker_ant
export(Color) var color


onready var spawn_point: Node2D = $Scale/SpawnPoint
var team_points: int = 0

onready var anthill_area: Area2D = $Scale/AnthillArea


func _ready():
	self_modulate = color


func _physics_process(delta):
	consume_consumables_in_anthill_area()


func consume_consumables_in_anthill_area():
	var consumables: Array = get_consumables_in_anthill_area()
	for consumable in consumables:
		consume(consumable)


func get_consumables_in_anthill_area():
	var physics_bodies_in_anthill_area: Array = anthill_area.get_overlapping_bodies()
	var consumable_bodies: Array = try_get_consumable_bodies(physics_bodies_in_anthill_area)
	return consumable_bodies


func try_get_consumable_bodies(physics_bodies: Array) -> Array:
	var result := Array()
	for body in physics_bodies:
		if is_consumable(body):
			result.append(body)
	return result


func is_consumable(object: Object) -> bool:
	return object.has_method("on_consumed")


func consume(consumable: Object) -> void:
	team_points += consumable.point_value
	consumable.on_consumed()
	print("We now have", team_points, "points!")


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
			ant.set_name(controller.player_info[Constants.PLAYER_INFO_NAME])
			
			# Tell the player to update the controller state
			controller.rpc_id(controller.player_network_id, "set_controller_state", 0)
