extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(int) var point_value = 0


var forces: Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


func _physics_process(delta):
	# Sum all the forces being applied to this object each physics frame
	var sum_forces: Vector2 = Vector2.ZERO
	
	for f in forces.values():
		sum_forces += f
	
	# Apply the ending result
	move_and_slide(sum_forces * delta)


func set_force(id, vel: Vector2):
	forces[id] = vel


func remove_force(id):
	forces.erase(id)


func on_grabbed():
	print("I done been grabbed! -Fruit")


func on_consumed():
	print("CONSUMED!!!")
	call_deferred("queue_free")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
