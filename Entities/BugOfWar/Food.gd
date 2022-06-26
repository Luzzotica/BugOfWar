extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(int) var point_value = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


func _physics_process(delta):
	linear_velocity = Vector2()


func on_grabbed():
	print("I done been grabbed! -Fruit")


func on_consumed():
	print("CONSUMED!!!")
	call_deferred("queue_free")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
