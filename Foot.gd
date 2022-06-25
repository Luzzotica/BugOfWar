extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var time_until_impact = 5.0

func setup(origin: Vector2):
	global_position = origin

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_until_impact -= delta
	
	# make the shadow bigger
	
	if time_until_impact < 0:
		# display the foot object
		# get the list of all objects inside me
		# destroy them all
		pass

func _do_stomp():
	
