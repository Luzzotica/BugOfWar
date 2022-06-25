extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const NULL_PATH = NodePath()

export var health: int = 100
export var speed: int = 200
export var hauling_multiplier: float = 0.5

var controller: PlayerController = null

var hauling = false

# onready var sprite: Sprite = get_node("Sprite")
onready var grab_zone: Area2D = $Pincers/GrabZone
onready var pincer_pin_joint: PinJoint2D = $Pincers/PinJoint2D

signal death()

func _ready():
	pass


func _physics_process(delta):
	if controller == null:
		return
		
	var vel = controller.direction
#
#	if Input.is_action_pressed("move_left"):
#		vel.x -= speed
#
#	if Input.is_action_pressed("move_right"):
#		vel.x += speed
#
#	if Input.is_action_pressed("move_down"):
#		vel.y += speed
#
#	if Input.is_action_pressed("move_up"):
#		vel.y -= speed

	

	if is_grabbing_something():
		linear_velocity = vel.normalized() * speed * hauling_multiplier
		look_at(get_grabbed_obj_position())
	else:
		linear_velocity = vel.normalized() * speed
		look_at(position + linear_velocity)
	
	if controller.grab_pressed:
		grab()
	else:
		let_go()


func is_grabbing_something() -> bool:
	return pincer_pin_joint.node_b != NULL_PATH


func get_grabbed_obj_position() -> Vector2:
	return get_node(pincer_pin_joint.node_b).position


func take_damage(dmg: int):
	health -= dmg
	
	if health <= 0:
		emit_signal("death")
		call_deferred("queue_free")


func let_go():
	pincer_pin_joint.node_b = NodePath()


func grab():
	# If we already have something, stop
	if hauling:
		return
	
	var physics_bodies_in_grab_zone: Array = grab_zone.get_overlapping_bodies()

	if physics_bodies_in_grab_zone.size() == 0:
		return

	var grabbable_body: PhysicsBody2D = try_get_grabbable_body(physics_bodies_in_grab_zone)

	if grabbable_body:
		hauling = true
		grabbable_body.on_grabbed()
		pincer_pin_joint.node_b = grabbable_body.get_path()


func try_get_grabbable_body(bodies: Array) -> PhysicsBody2D:
	for body in bodies:
		if is_grabbable(body):
			return body
	return null


func is_grabbable(object: Object) -> bool:
	return object.has_method("on_grabbed")


""" SIGNALS """
