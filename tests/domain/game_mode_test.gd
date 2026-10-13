extends RefCounted

const GameModeScript := preload("res://domain/state/game_mode.gd")
const GameStateScript := preload("res://domain/state/game_state.gd")


func run() -> bool:
	if not _initial_mode_is_main_menu():
		return false
	if not _dialogue_replaces_exploration():
		return false
	if not _unknown_mode_cannot_be_constructed():
		return false
	return true


func _initial_mode_is_main_menu() -> bool:
	var state: RefCounted = GameStateScript.new()
	var mode: Variant = state.get("mode")
	if mode == null:
		return false
	if mode.get("id") != GameModeScript.MAIN_MENU:
		return false
	return _eight_modes_exist()


func _eight_modes_exist() -> bool:
	var ids: Array[StringName] = [
		GameModeScript.MAIN_MENU,
		GameModeScript.EXPLORATION,
		GameModeScript.DIALOGUE,
		GameModeScript.CHOICE,
		GameModeScript.COMBAT,
		GameModeScript.PAUSE,
		GameModeScript.LOADING,
		GameModeScript.SAVING,
	]
	if ids.size() != 8:
		return false
	var seen: Dictionary = {}
	for id in ids:
		var mode: Variant = GameModeScript.create(id)
		if mode == null or mode.get("id") != id:
			return false
		seen[id] = true
	return seen.size() == 8


func _dialogue_replaces_exploration() -> bool:
	var state: RefCounted = GameStateScript.new()
	var exploration: Variant = GameModeScript.create(GameModeScript.EXPLORATION)
	if exploration == null:
		return false
	state.set("mode", exploration)
	if state.get("mode") != exploration:
		return false
	var dialogue: Variant = GameModeScript.create(GameModeScript.DIALOGUE)
	if dialogue == null:
		return false
	state.set("mode", dialogue)
	return state.get("mode") == dialogue


func _unknown_mode_cannot_be_constructed() -> bool:
	if GameModeScript.create(&"cutscene") != null:
		return false
	var mode: Variant = GameModeScript.new()
	if mode == null or mode.get("id") != GameModeScript.MAIN_MENU:
		return false
	mode.set("id", &"cutscene")
	return mode.get("id") == GameModeScript.MAIN_MENU
