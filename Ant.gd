extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var health: int = 100
var speed: int = 200

# onready var sprite: Sprite = get_node("Sprite")
onready var grab_zone: Area2D = $GrabZone


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
	
	look_at(position + linear_velocity)
	
	
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func take_damage(dmg: int):
	health -= dmg
	
	if health <= 0:
		death()

func death():
	pass

func grab():
	var physics_bodies_in_grab_zone: Array = grab_zone.get_overlapping_bodies()
	
	if physics_bodies_in_grab_zone.size() == 0:
		return 
		
	var grabbable_body: PhysicsBody2D = \
		try_get_grabbable_body(physics_bodies_in_grab_zone)
		
	
	
	
		
func try_get_grabbable_body(bodies: Array) -> PhysicsBody2D:
	for body in bodies:
		if is_grabbable(body):
			return body
	return null
	
	

func is_grabbable(object) -> bool:
	return object.has_method("on_grabbed")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
