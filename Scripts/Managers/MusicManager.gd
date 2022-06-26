extends Node

var tracks = null

var music: Resource = null

const min_vol = -50.0
const vol = -10
const fade_rate = (vol - min_vol) / 3

func _ready():
	if tracks == null:
		load_music()
	if (music== null || !$Music.playing):
		play_track(2)


func load_music():
	tracks = Array()
	var dir_path = "res://resources/audio/BackgroundMusic/"
	var dir = Directory.new()
	dir.open(dir_path)
	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if dir.current_is_dir():
			pass
		elif ".import" in file_name:
			pass
		else:
			tracks.append(load(dir_path + "/" + file_name))
		file_name = dir.get_next()


func play_track(id: int):
	play_music(tracks[id])


func play_music(track: Resource):
	if (music == track):
		if(!$Music.playing):
			$Music.play()
		return
	music = track
	$Music.stream = music
	$Music.volume_db = vol
	$Music.play()
	
func stop_music():
	$Music.stop()
	
func fade_out_music():
	_fading_out = true

var _fading_out : bool = false

func _process(delta):
	if (_fading_out):
		if ($Music.volume_db <= vol):
			_fading_out = false
			stop_music()
		else:
			$Music.volume_db -= fade_rate * delta
