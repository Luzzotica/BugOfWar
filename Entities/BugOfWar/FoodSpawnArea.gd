extends Node2D
class_name FoodSpawnArea

export(int) var max_food_items = 2
export(float) var min_wait_time_seconds = 1
export(float) var max_wait_time_seconds = 5
export(PackedScene) var Food

onready var food_group: Node = $FoodGroup
onready var spawn_area_shape: CollisionShape2D = $SpawnArea/Shape
onready var spawn_area_rect: RectangleShape2D = spawn_area_shape.shape
onready var spawn_timer: Timer = $SpawnTimer


func _ready():
#	spawn_timer.connect("timeout", self, "_on_spawn_wait_timeout")
	start_random_wait()


func _on_SpawnTimer_timeout():
	print("Wait complete!")
	spawn_food_if_should()
	start_random_wait()


func spawn_food_if_should() -> void:
	print("Time remaining ", spawn_timer.time_left, " is_wait_complete() ", is_wait_complete())

	if not is_max_food_spawned():
		spawn_food_in_random_position_in_spawn_area()


func spawn_food_in_random_position_in_spawn_area():
	var random_pos: Vector2 = get_random_position_in_spawn_area()
	spawn_food(random_pos)


func spawn_food(init_pos: Vector2) -> void:
	print("Spawning new food at ", init_pos)

	var new_food = Food.instance()
	new_food.position = init_pos
	new_food.point_value = 10

	food_group.add_child(new_food)


func get_current_food_count() -> int:
	return food_group.get_child_count()


func start_random_wait() -> void:
	var wait_time: float = get_wait_time_seconds()
	spawn_timer.start()
	spawn_timer.set_wait_time(wait_time)
	print("Starting a ", wait_time, " second wait.")


func is_wait_complete() -> bool:
	return spawn_timer.time_left <= 0


func is_max_food_spawned() -> bool:
	return get_current_food_count() >= max_food_items


func get_wait_time_seconds() -> float:
	return rand_range(min_wait_time_seconds, max_wait_time_seconds)

func get_random_position_in_spawn_area() -> Vector2:
	var spawn_position: Vector2 = RandomCoordinateFactory.get_point_in_rectangle(spawn_area_rect)
	return spawn_position
