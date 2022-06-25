extends Node2D

export(PackedScene) var foot
export(PackedScene) var fire
export(PackedScene) var droplet

var rng = RandomNumberGenerator.new()

enum Frequencies {
	XSHORT = 0
	SHORT = 1
	MEDIUM = 2
	LONG = 3
	XLONG = 4
	NEVER = 5
}

enum Disasters {
	FOOT = 0
	FIRE = 1
	DROPLET = 2
}

# Declare member variables here.
var time_until_next_disaster = INF
var mean_frequency = INF
var variance = 0
var disaster_area = null

var paused = true

# Called when the node enters the scene tree for the first time.
func _ready():
	# reset the disaster timer
	_reset_disaster_timer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if paused:
		return
	
	time_until_next_disaster -= delta
	
	if time_until_next_disaster < 0:
		_spawn_disaster()
		_reset_disaster_timer()

func _reset_disaster_timer():
	if mean_frequency < INF:
		time_until_next_disaster = rng.randfn(mean_frequency, variance)

func _spawn_disaster(spawn_seed: int = -1):
	# get disaster origin
	var origin = RandomCoordinateFactory.get_point_in_area(disaster_area)
	var rotation = rng.randf_range(0,180)
	# select a disaster type
	# spawn that object, and let it go do its thing
	var disaster_type : int
	if (spawn_seed in range(0,2)):
		disaster_type = spawn_seed
	else:
		disaster_type = rng.randi_range(0,2)
	
	var disaster_instance = null
	
	if disaster_type == 0:
		# foot
		disaster_instance = foot.instance()
	elif disaster_type == 1:
		# fire
		disaster_instance = fire.instance()
	elif disaster_type == 2:
		# droplet
		disaster_instance = droplet.instance()
	else:
		print("Invalid disaster type: ", disaster_type)
	
	# setup the instance with the origin
	disaster_instance.setup(origin, rotation)
	# add the disaster to the disaster area
	disaster_area.add_child(disaster_instance)

func set_disaster_frequency(freq):
	if freq == Frequencies.XSHORT:
		mean_frequency = 7
	elif freq == Frequencies.SHORT:
		mean_frequency = 22
	elif freq == Frequencies.MEDIUM:
		mean_frequency = 37
	elif freq == Frequencies.LONG:
		mean_frequency = 52
	elif freq == Frequencies.XLONG:
		mean_frequency = 67
	elif freq == Frequencies.NEVER:
		pass
	else:
		# this is an error
		print("Invalid disaster freqency: ", freq)
		
	# else leave the default value of infinity
	if mean_frequency < INF:
		variance = mean_frequency / 5.0

func set_disaster_area(area: Area2D):
	disaster_area = area

func pause():
	paused = true

func unpause():
	paused = false
