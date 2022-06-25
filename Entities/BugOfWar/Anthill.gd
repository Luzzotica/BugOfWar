extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var team_points: int = 0

onready var anthill_area: Area2D = $"Anthill Area"


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


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
