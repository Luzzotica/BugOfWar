extends Node2D


signal frame_input(input)
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
	emit_signal("frame_input", {
		"d": dir,
		"g": Input.is_action_pressed("grab"),
		"s": Input.is_action_pressed("special")
	})


func reliable_action(info: Dictionary):
	emit_signal("reliable_action", info)


