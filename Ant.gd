extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


const NULL_PATH = NodePath()

var health: int = 100
var speed: int = 200

# onready var sprite: Sprite = get_node("Sprite")
onready var grab_zone: Area2D = $Pincers/GrabZone
onready var pinsir_pin_joint: PinJoint2D = $Pincers/PinJoint2D


func _physics_process(delta):

	var vel: Vector2 = Vector2(0, 0)
	
	if Input.is_action_pressed("move_left"):
		vel.x -= speed
		
	if Input.is_action_pressed("move_right"):
		vel.x += speed
		
	if Input.is_action_pressed("move_down"):
		vel.y += speed
		
	if Input.is_action_pressed("move_up"):
		vel.y -= speed
		
#	vel = move_and_slide(vel, Vector2.UP)
	linear_velocity = vel.normalized() * speed
	
	if is_grabbing_something():
		look_at(get_grabbed_obj_position())
	else:
		look_at(position + linear_velocity)
	
	if Input.is_action_pressed("grab"):
		grab()
	else:
		let_go()

func is_grabbing_something() -> bool:
	return pinsir_pin_joint.node_b != NULL_PATH
	
func get_grabbed_obj_position() -> Vector2:
	return get_node(pinsir_pin_joint.node_b).position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func take_damage(dmg: int):
	health -= dmg

func let_go():
	pinsir_pin_joint.node_b = NodePath()

func grab():
	var physics_bodies_in_grab_zone: Array = grab_zone.get_overlapping_bodies()
	
	if physics_bodies_in_grab_zone.size() == 0:
		return
		
	var grabbable_body: PhysicsBody2D = \
		try_get_grabbable_body(physics_bodies_in_grab_zone)
		
	if grabbable_body:
		grabbable_body.on_grabbed()
		pinsir_pin_joint.node_b = grabbable_body.get_path()
		

func try_get_grabbable_body(bodies: Array) -> PhysicsBody2D:
	for body in bodies:
		if is_grabbable(body):
			return body
	return null
	
	
func is_grabbable(object: Object) -> bool:
	return object.has_method("on_grabbed")
