extends Control

const READY = "ready"
const IN_TEAM = "in_team"

onready var team1 = $Panel/HBoxContainer/LobbyTeam
onready var team2 = $Panel/HBoxContainer/LobbyTeam2

var lobby_player_info: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerControllerManager.connect("new_player", self, "_on_new_player")
	# Link the controllers to the game
	for playerCont in PlayerControllerManager.player_controllers.values():
		_on_new_player(playerCont)


""" SIGNALS """

func _on_new_player(controller: PlayerController):
	controller.connect("team_changed", self, "_on_add_member_to_team")
	controller.connect("lobby_ready", self, "_on_player_ready")
	lobby_player_info[controller] = {READY: false, IN_TEAM: false}


func _on_add_member_to_team(member: PlayerController, team: int):
	print('adding ', member[Constants.PLAYER_INFO_NAME], ' to team: ', team)
	lobby_player_info[member][IN_TEAM] = true
	if team == 1:
		team2.remove_member(member)
		team1.add_member(member, lobby_player_info[member][READY])
	elif team == 2:
		team1.remove_member(member)
		team2.add_member(member, lobby_player_info[member][READY])
	else:
		lobby_player_info[member][IN_TEAM] = false
	print(lobby_player_info)


func _on_player_ready(member: PlayerController, what: bool):
	print('readying player: ', member[Constants.PLAYER_INFO_NAME], what)
	lobby_player_info[member][READY] = what
	team1.set_member_ready(member, what)
	team2.set_member_ready(member, what)

	# If all players are ready, let's start
	print(lobby_player_info)
	if all_players_ready():
		NetworkManager.rpc("game_state_start")


""" HELPERS """

func all_players_ready() -> bool:
	for value in lobby_player_info.values():
		if not value[READY] or not value[IN_TEAM]:
			return false

	return true
