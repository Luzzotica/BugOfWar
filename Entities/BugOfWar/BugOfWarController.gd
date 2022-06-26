extends Control

onready var generic_actions = $GenericActions
onready var choose_your_ant = $ChooseAnt

var state = 0


func set_state(state: int):
	self.state = state
	print('setting state: ', state)
	generic_actions.visible = false
	choose_your_ant.visible = false
	if state == 0:
		generic_actions.visible = true
	elif state == 1:
		choose_your_ant.visible = true


func _on_Grab_button_down():
	Input.action_press("grab")


func _on_Grab_button_up():
	Input.action_release("grab")


func _on_Special_button_down():
	Input.action_press("special")


func _on_Special_button_up():
	Input.action_release("special")


func _on_WorkerAnt_pressed():
	InputManager.reliable_action({Constants.COMMAND: Constants.BUG_OF_WAR_COMMAND_SPAWN_WORKER_ANT})


func _on_player_controller_state_change(state: int):
	set_state(state)
