class_name WorldState
extends RefCounted

## Boolean narrative flags keyed by id. A missing id reads as false.
## Flag names are supplied by later events; this object does not list them.


var _flags: Dictionary[StringName, bool] = {}


func set_flag(id: StringName, value: bool) -> void:
	if id.is_empty():
		return
	_flags[id] = value


func get_flag(id: StringName) -> bool:
	return _flags.get(id, false)


func flags() -> Dictionary:
	return _flags.duplicate()
