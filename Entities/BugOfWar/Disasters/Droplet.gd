extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
#	Pick a random droplet to make visible
	var drop = random.choice(self.get_children())
	drop.visible = true
