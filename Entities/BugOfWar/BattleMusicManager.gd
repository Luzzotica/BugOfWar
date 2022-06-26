extends Node

var _audio_players = Array()
var _fading_in = Array()
var _fading_out = Array()

var main_track: int = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	MusicManager.fade_out_music()
	# start fading in the music
	_create_track(1)
	main_track = 0
	fade_in_music(0)
#	var timer = Timer.new()
#	timer.connect("timeout",self, "transition")
#	timer.connect("timeout",timer,"stop")
#	add_child(timer)
#	timer.start(8)
	
func transition():
#	print("transitioning")
	if(_audio_players.size() == 1):
		_create_track(0)
	if (main_track == 1):
		fade_in_music(0)
		fade_out_music(1)
	elif (main_track == 0):
		fade_in_music(1)
		fade_out_music(0)
	else:
		print("Don't know what track to transition to.")

func _create_track(index: int):
	var newPlayer = AudioStreamPlayer.new()
	newPlayer.volume_db = MusicManager.min_vol
	newPlayer.stream = MusicManager.tracks[index]
	add_child(newPlayer)
	_fading_in.append(false)
	_fading_out.append(false)
	_audio_players.append(newPlayer)

func fade_in_music(index: int):
	if(_fading_out[index] == true):
		_fading_out[index] = false
	_fading_in[index] = true
	_audio_players[index].volume_db = MusicManager.min_vol
	_audio_players[index].play()
	main_track = index

func fade_out_music(index: int):
	if(_fading_in[index] == true):
		_fading_in[index] = false
	_fading_out[index] = true

func _process(delta):
	if Input.is_action_just_pressed("change_music"):
		transition()
	for i in range(len(_audio_players)):
		if(_fading_in[i]):
			if (_audio_players[i].volume_db >= MusicManager.vol):
				_fading_in[i] = false
			else:
				_audio_players[i].volume_db += MusicManager.fade_rate * delta
		elif(_fading_out[i]):
			if (_audio_players[i].volume_db <= MusicManager.min_vol):
				_fading_out[i] = false
				_audio_players[i].stop()
			else:
				_audio_players[i].volume_db -= MusicManager.fade_rate * delta
