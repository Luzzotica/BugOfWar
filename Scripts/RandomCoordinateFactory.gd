extends Node2D

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_point_in_area(area: Area2D) -> Vector2:
	# get the size of the shape
	var extent = area.shape.extents
	# get the center, but then modify it to be the corner of the area
	var origin = area.global_position - extent/2.0
	# uniformly generate an X and a Y inside the rectangle's area
	var x = rng.randf_range(origin.x, extent.x)
	var y = rng.randf_range(origin.y, extent.y)
	# convert to Vector2 and return
	return Vector2(x, y)
