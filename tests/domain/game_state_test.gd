extends RefCounted

const GameStateScript := preload("res://domain/state/game_state.gd")
const PlayerStateScript := preload("res://domain/state/player_state.gd")
const WorldStateScript := preload("res://domain/state/world_state.gd")


func run() -> bool:
	if not _initial_session_slots():
		return false
	if not _save_metadata_is_an_empty_dictionary():
		return false
	return true


func _initial_session_slots() -> bool:
	var state: RefCounted = GameStateScript.new()
	var player: Variant = state.get("player")
	if player == null or player.get_script() != PlayerStateScript:
		return false
	var world: Variant = state.get("world")
	if world == null or world.get_script() != WorldStateScript:
		return false
	var other: RefCounted = GameStateScript.new()
	if other.get("player") == player:
		return false
	if other.get("world") == world:
		return false
	if state.get("party") != null:
		return false
	if state.get("mission") != null:
		return false
	if state.get("current_scene_id") != "":
		return false
	return true


func _save_metadata_is_an_empty_dictionary() -> bool:
	var state: RefCounted = GameStateScript.new()
	var metadata: Variant = state.get("save_metadata")
	if typeof(metadata) != TYPE_DICTIONARY:
		return false
	if not (metadata as Dictionary).is_empty():
		return false

	var other: RefCounted = GameStateScript.new()
	(metadata as Dictionary)["slot"] = 1
	var other_metadata: Variant = other.get("save_metadata")
	return (other_metadata as Dictionary).is_empty()
