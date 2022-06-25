extends Control

onready var generic_actions = $GenericActions
onready var choose_your_ant = $ChooseAnt

var state = 0

signal reliable_action(info)


func set_state(state: int):
	self.state = state
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
	InputManager.reliable_action({"spawn_ant": "worker_ant"})
