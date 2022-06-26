extends Node2D

onready var foot_right_one = $Skeleton/LegUpperR3/LegLower/Foot
onready var foot_right_one_target: Node2D = $LegR1Target
onready var foot_right_one_current_target: Vector3 = foot_right_one.global_position

var distance = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	foot_right_one.global_position = foot_right_one_current_target
	if foot_right_one.global_position.distance_to(foot_right_one_target.global_position) > distance:
		pass
