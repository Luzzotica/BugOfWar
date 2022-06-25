extends Node2D

export(PackedScene) var worker_ant

onready var ant_holder = $AntHolder
onready var team1_anthill = $Anthills/AnthillL
onready var team2_anthill = $Anthills/AnthillR

# Called when the node enters the scene tree for the first time.
func _ready():
	# FOR LOCAL DEV
#	$PlayerController.setup_local()
#	$Ant.controller = $PlayerController
	
	# Link the controllers to the game
	print(PlayerControllerManager.player_controllers.values().size())
	for playerCont in PlayerControllerManager.player_controllers.values():
		print('Connecting player: ', playerCont[PlayerControllerManager.CONTROLLER].player_info)
		playerCont[PlayerControllerManager.CONTROLLER].connect("action", self, "_on_player_action")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_player_action(player: PlayerController, info: Dictionary):
	print('recieved command')
	if Constants.COMMAND in info:
		var anthill = get_anthill_by_team(player.team)
		anthill.spawn_ant(player, info[Constants.COMMAND])


func get_anthill_by_team(team: int):
	if team == 1:
		return team1_anthill
	else:
		return team2_anthill
