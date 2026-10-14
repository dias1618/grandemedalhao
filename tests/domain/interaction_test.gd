extends RefCounted

const TryInteractScript := preload("res://application/interaction/try_interact.gd")
const InteractionTargetScript := preload("res://domain/interaction/interaction_target.gd")
const GameStateScript := preload("res://domain/state/game_state.gd")
const GameModeScript := preload("res://domain/state/game_mode.gd")
const InputFrameScript := preload("res://application/input/input_frame.gd")
const InputActionScript := preload("res://application/input/input_action.gd")
const EnterSceneScript := preload("res://application/enter_scene.gd")


func run() -> bool:
	if not _in_range_in_bar_during_exploration_returns_old_man_conversation():
		return false
	if not _distance_64_succeeds_and_65_fails_without_changing_session():
		return false
	if not _dialogue_returns_no_target():
		return false
	return _outside_returns_no_target()


func _in_range_in_bar_during_exploration_returns_old_man_conversation() -> bool:
	var target: RefCounted = InteractionTargetScript.old_man()
	if target.get("id") != "old_man":
		return false
	if target.get("conversation_id") != "old_man_conversation":
		return false
	if float(target.get("range")) != 64.0:
		return false
	var origin: Vector2 = target.get("position")
	var state := _session(GameModeScript.EXPLORATION, "bar", origin)
	if TryInteractScript.execute(state, _idle_frame()) != "":
		return false
	if not _session_unchanged(state, GameModeScript.EXPLORATION, "bar"):
		return false
	var result: String = TryInteractScript.execute(state, _interact_frame())
	if result != "old_man_conversation":
		return false
	return _session_unchanged(state, GameModeScript.EXPLORATION, "bar")


func _distance_64_succeeds_and_65_fails_without_changing_session() -> bool:
	var target: RefCounted = InteractionTargetScript.old_man()
	var origin: Vector2 = target.get("position")
	var inside := _session(GameModeScript.EXPLORATION, "bar", origin + Vector2(64, 0))
	if TryInteractScript.execute(inside, _interact_frame()) != "old_man_conversation":
		return false
	if not _session_unchanged(inside, GameModeScript.EXPLORATION, "bar"):
		return false
	var outside := _session(GameModeScript.EXPLORATION, "bar", origin + Vector2(65, 0))
	if TryInteractScript.execute(outside, _interact_frame()) != "":
		return false
	return _session_unchanged(outside, GameModeScript.EXPLORATION, "bar")


func _dialogue_returns_no_target() -> bool:
	var target: RefCounted = InteractionTargetScript.old_man()
	var state := _session(GameModeScript.DIALOGUE, "bar", target.get("position"))
	if TryInteractScript.execute(state, _interact_frame()) != "":
		return false
	return _session_unchanged(state, GameModeScript.DIALOGUE, "bar")


func _outside_returns_no_target() -> bool:
	var target: RefCounted = InteractionTargetScript.old_man()
	var state := _session(GameModeScript.EXPLORATION, "outside", target.get("position"))
	if TryInteractScript.execute(state, _interact_frame()) != "":
		return false
	return _session_unchanged(state, GameModeScript.EXPLORATION, "outside")


func _session(mode_id: StringName, scene_id: String, position: Vector2) -> RefCounted:
	var state: RefCounted = GameStateScript.new()
	state.get("mode").set("id", mode_id)
	EnterSceneScript.enter(state, scene_id)
	state.get("player").set("position", position)
	state.get("world").call("set_flag", &"kept_flag", true)
	return state


func _session_unchanged(state: RefCounted, mode_id: StringName, scene_id: String) -> bool:
	if state.get("mode").get("id") != mode_id:
		return false
	if state.get("current_scene_id") != scene_id:
		return false
	var flags: Dictionary = state.get("world").call("flags")
	return flags.size() == 1 and flags.get("kept_flag") == true


func _interact_frame() -> RefCounted:
	var frame: RefCounted = InputFrameScript.new()
	frame.call("set_just_pressed", InputActionScript.INTERACT, true)
	return frame


func _idle_frame() -> RefCounted:
	return InputFrameScript.new()
