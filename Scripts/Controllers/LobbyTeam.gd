extends Control

export (PackedScene) var lobby_team_member

onready var team_member_list: Control = $VBoxContainer/TeamMembers

var members: Dictionary = {}
var max_members: int = 4


func add_member(member: PlayerController, ready: bool) -> bool:
	if members.size() == max_members:
		print("Max team size reached")
		return false
	elif member in members:
		print("Member already exists")
		return false
	
	var member_component = lobby_team_member.instance()
	team_member_list.add_child(member_component)
	member_component.set_name(member.player_info[Constants.PLAYER_INFO_NAME])
	member_component.set_ready(ready)
	members[member] = member_component
	return true


func remove_member(member: PlayerController):
	print('Removing members: ', member[Constants.PLAYER_INFO_NAME])
	print('Is in members list: ', member in members)
	print(members)
	if member in members:
		members[member].queue_free()
		members.erase(member)


func set_member_ready(member: PlayerController, ready: bool):
	if member in members:
		members[member].set_ready(ready)


