extends RefCounted

const SceneIdScript := preload("res://domain/scene/scene_id.gd")
const EnterSceneScript := preload("res://application/enter_scene.gd")
const GameStateScript := preload("res://domain/state/game_state.gd")
const GameModeScript := preload("res://domain/state/game_mode.gd")


func run() -> bool:
	if not _outside_is_valid():
		return false
	if not _three_known_ids_are_the_full_set():
		return false
	if not _unknown_id_is_rejected_and_does_not_change_current_scene():
		return false
	if not _entering_a_scene_does_not_change_world_flags():
		return false
	return true


func _outside_is_valid() -> bool:
	if not SceneIdScript.is_known("outside"):
		return false
	var state: RefCounted = GameStateScript.new()
	if state.get("current_scene_id") != "":
		return false
	if not EnterSceneScript.enter(state, "outside"):
		return false
	if state.get("current_scene_id") != "outside":
		return false
	return _session_aside_from_scene_stays_put(state)


func _three_known_ids_are_the_full_set() -> bool:
	var expected: Array[String] = ["outside", "bar", "pirate_cave"]
	var known: Array = SceneIdScript.known_ids()
	if known.size() != expected.size():
		return false
	for id in expected:
		if not SceneIdScript.is_known(id):
			return false
		if id not in known:
			return false
	if SceneIdScript.is_known("OUTSIDE"):
		return false
	if SceneIdScript.is_known("BAR"):
		return false
	if SceneIdScript.is_known("PIRATE_CAVE"):
		return false
	if SceneIdScript.is_known(""):
		return false
	return known.size() == 3


func _unknown_id_is_rejected_and_does_not_change_current_scene() -> bool:
	var state: RefCounted = GameStateScript.new()
	if EnterSceneScript.enter(state, "unknown"):
		return false
	if state.get("current_scene_id") != "":
		return false
	if not EnterSceneScript.enter(state, "outside"):
		return false
	if EnterSceneScript.enter(state, "OUTSIDE"):
		return false
	if state.get("current_scene_id") != "outside":
		return false
	if not EnterSceneScript.enter(state, "pirate_cave"):
		return false
	return state.get("current_scene_id") == "pirate_cave"


func _entering_a_scene_does_not_change_world_flags() -> bool:
	var state: RefCounted = GameStateScript.new()
	var world: Variant = state.get("world")
	world.call("set_flag", &"kept_flag", true)
	var before: Dictionary = world.call("flags")
	if not EnterSceneScript.enter(state, "outside"):
		return false
	if not EnterSceneScript.enter(state, "bar"):
		return false
	if EnterSceneScript.enter(state, "not_a_scene"):
		return false
	var after: Dictionary = world.call("flags")
	if after.size() != 1 or after.get("kept_flag") != true:
		return false
	if before.get("kept_flag") != true:
		return false
	return _session_aside_from_scene_stays_put(state)


func _session_aside_from_scene_stays_put(state: RefCounted) -> bool:
	if state.get("mission") != null:
		return false
	var mode: Variant = state.get("mode")
	if mode == null or mode.get("id") != GameModeScript.MAIN_MENU:
		return false
	var player: Variant = state.get("player")
	if player == null or player.get("scene_id") != "":
		return false
	return true
