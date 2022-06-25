extends Node

var tracks = null

var music: Resource = null

func _ready():
	if (tracks == null):
		load_music()
	if (music == null):
		play_track(0)

func load_music():
	tracks = Array()
	var dir_path = "res://AudioResources/BackgroundMusic"
	var dir = Directory.new()
	dir.open(dir_path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while(file_name!=""): 
		if dir.current_is_dir():
			pass
		elif (".import" in file_name):
			pass
		else:
			tracks.append(load(dir_path+"/"+file_name))
		file_name = dir.get_next()
	

func play_track(id : int):
	play_music(tracks[id])

func play_music(track : Resource):
	music = track
	$Music.stream = music
	$Music.play()
