extends Node2D


signal joystick_input(direction)
signal unreliable_action(info)
signal reliable_action(info)

func _process(delta):
	var dir = Vector2.ZERO
	
	if Input.is_action_pressed("w"):
		dir.y -= 1
	if Input.is_action_pressed("a"):
		dir.x -= 1
	if Input.is_action_pressed("s"):
		dir.y += 1
	if Input.is_action_pressed("d"):
		dir.x += 1
	
	dir = dir.normalized()
	emit_signal("joystick_input", dir)
	
	if Input.is_action_pressed("grab"):
		reliable_action("grab")
	
	if Input.is_action_just_pressed("special"):
		emit_signal("reliable_action", "special")


func reliable_action(info: String):
	emit_signal("reliable_action", info)


func unreliable_action(info: String):
	emit_signal("unreliable_action", info)


