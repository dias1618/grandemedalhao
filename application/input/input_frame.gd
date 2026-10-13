class_name InputFrame
extends RefCounted

## Read model of actions held or just pressed.
## Constructed without the Input singleton so tests can build a frame directly.


var _held: Dictionary = {}
var _just_pressed: Dictionary = {}


func set_held(action: StringName, held: bool = true) -> bool:
	if not InputAction.is_known(action):
		return false
	if held:
		_held[action] = true
	else:
		_held.erase(action)
	return true


func set_just_pressed(action: StringName, just_pressed: bool = true) -> bool:
	if not InputAction.is_known(action):
		return false
	if just_pressed:
		_just_pressed[action] = true
	else:
		_just_pressed.erase(action)
	return true


func is_held(action: StringName) -> bool:
	return _held.has(action)


func is_just_pressed(action: StringName) -> bool:
	return _just_pressed.has(action)
