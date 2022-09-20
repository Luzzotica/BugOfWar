extends KinematicBody2D

const NULL_PATH = NodePath()

export var health: int = 100
export var speed: int = 15000
export var hauling_multiplier: float = 0.5

# onready var sprite: Sprite = get_node("Sprite")
onready var grab_zone: Area2D = $Pincers/GrabZone
onready var pincer_pin_joint: PinJoint2D = $Pincers/PinJoint2D
onready var name_tag_holder: Node2D = $NameTag
onready var name_tag: Label = $NameTag/Control/Label
onready var sprite: Sprite = $Icon

var controller: PlayerController = null
var player_name_tag: String = ""
var curr_velocity: Vector2 = Vector2.ZERO
var grabbed_obj = null

signal death


func _process(delta):
	name_tag_holder.global_rotation = 0


func _physics_process(delta):
	if controller == null:
		return
	
	var dir = controller.direction
	curr_velocity = dir * speed
	
	if is_grabbing_something():
		curr_velocity = curr_velocity * hauling_multiplier
	
	look_at(get_look_at_pos())
	
	var actual_movement: Vector2 = move_and_slide(curr_velocity * delta)
	if is_grabbing_something():
		grabbed_obj.set_force(name, actual_movement / delta)
	
	if controller.grab_pressed:
		grab()
	else:
		let_go()


func is_grabbing_something() -> bool:
	return is_instance_valid(grabbed_obj)
#	return pincer_pin_joint.node_b != NULL_PATH and get_node(pincer_pin_joint.node_b) != null


func get_look_at_pos() -> Vector2:
	if is_grabbing_something():
		return grabbed_obj.global_position
	return global_position * curr_velocity
#	return get_node(pincer_pin_joint.node_b).global_position


func take_damage(dmg: int):
	health -= dmg

	if health <= 0:
		emit_signal("death")
		call_deferred("queue_free")


func let_go():
	if is_grabbing_something():
		grabbed_obj.remove_force(name)
	
	grabbed_obj = null
#	pincer_pin_joint.node_b = NodePath()


func grab():
	# If we already have something, stop
	if is_grabbing_something():
		return

	var physics_bodies_in_grab_zone: Array = grab_zone.get_overlapping_bodies()

	if physics_bodies_in_grab_zone.size() == 0:
		return

	var grabbable_body: PhysicsBody2D = try_get_grabbable_body(physics_bodies_in_grab_zone)

	if grabbable_body:
		grabbable_body.on_grabbed()
		grabbed_obj = grabbable_body
#		pincer_pin_joint.node_b = grabbable_body.get_path()


func try_get_grabbable_body(bodies: Array) -> PhysicsBody2D:
	for body in bodies:
		if is_grabbable(body):
			return body
	return null


func is_grabbable(object: Object) -> bool:
	return object.has_method("on_grabbed")


func set_name_tag(tag: String):
	name_tag.text = tag


func set_color(c: Color):
	sprite.self_modulate = c


func set_controller(cont: PlayerController):
	PlayerControllerManager.player_controllers[cont.player_network_id]


""" SIGNALS """
