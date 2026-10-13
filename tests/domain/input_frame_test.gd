extends RefCounted

const InputActionScript := preload("res://application/input/input_action.gd")
const InputFrameScript := preload("res://application/input/input_frame.gd")


func run() -> bool:
	if not _held_move_action_is_reported():
		return false
	if not _unset_action_is_not_held():
		return false
	if not _unknown_action_cannot_be_inserted():
		return false
	if not _move_up_held_and_confirm_just_pressed():
		return false
	return _nine_actions_exist()


func _held_move_action_is_reported() -> bool:
	var frame: RefCounted = InputFrameScript.new()
	if not frame.call("set_held", InputActionScript.MOVE_RIGHT, true):
		return false
	return frame.call("is_held", InputActionScript.MOVE_RIGHT)


func _unset_action_is_not_held() -> bool:
	var frame: RefCounted = InputFrameScript.new()
	frame.call("set_held", InputActionScript.MOVE_LEFT, true)
	return not frame.call("is_held", InputActionScript.MOVE_RIGHT)


func _unknown_action_cannot_be_inserted() -> bool:
	var frame: RefCounted = InputFrameScript.new()
	if frame.call("set_held", &"inventory", true):
		return false
	if frame.call("set_just_pressed", &"pause_menu", true):
		return false
	if frame.call("is_held", &"inventory"):
		return false
	return not frame.call("is_just_pressed", &"pause_menu")


func _move_up_held_and_confirm_just_pressed() -> bool:
	var frame: RefCounted = InputFrameScript.new()
	if not frame.call("set_held", InputActionScript.MOVE_UP, true):
		return false
	if not frame.call("set_just_pressed", InputActionScript.CONFIRM, true):
		return false
	if not frame.call("is_held", InputActionScript.MOVE_UP):
		return false
	if frame.call("is_held", InputActionScript.CONFIRM):
		return false
	if not frame.call("is_just_pressed", InputActionScript.CONFIRM):
		return false
	return not frame.call("is_just_pressed", InputActionScript.MOVE_UP)


func _nine_actions_exist() -> bool:
	var ids: Array[StringName] = [
		InputActionScript.MOVE_UP,
		InputActionScript.MOVE_DOWN,
		InputActionScript.MOVE_LEFT,
		InputActionScript.MOVE_RIGHT,
		InputActionScript.INTERACT,
		InputActionScript.RUN,
		InputActionScript.CONFIRM,
		InputActionScript.BACK,
		InputActionScript.PAUSE,
	]
	if ids.size() != 9:
		return false
	var seen: Dictionary = {}
	for id in ids:
		if not InputActionScript.is_known(id):
			return false
		seen[id] = true
	if seen.size() != 9:
		return false
	return not InputActionScript.is_known(&"inventory") and not InputActionScript.is_known(&"pause_menu")
