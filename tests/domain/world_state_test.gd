extends RefCounted

const WorldStateScript := preload("res://domain/state/world_state.gd")


func run() -> bool:
	if not _set_example_flag_reads_back_true():
		return false
	if not _unset_flag_reads_false():
		return false
	if not _empty_flag_id_is_rejected():
		return false
	return true


func _set_example_flag_reads_back_true() -> bool:
	var world: RefCounted = WorldStateScript.new()
	world.call("set_flag", &"example_flag", true)
	return world.call("get_flag", &"example_flag") == true


func _unset_flag_reads_false() -> bool:
	var world: RefCounted = WorldStateScript.new()
	return world.call("get_flag", &"missing_flag") == false


func _empty_flag_id_is_rejected() -> bool:
	var world: RefCounted = WorldStateScript.new()
	world.call("set_flag", &"", true)
	if world.call("get_flag", &"") == true:
		return false
	var stored: Variant = world.call("flags")
	if typeof(stored) != TYPE_DICTIONARY:
		return false
	return (stored as Dictionary).is_empty()
