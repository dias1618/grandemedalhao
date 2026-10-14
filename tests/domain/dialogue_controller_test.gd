extends RefCounted

const DialogueControllerScript := preload("res://application/dialogue/dialogue_controller.gd")
const OldManConversationScript := preload("res://domain/dialogue/old_man_conversation.gd")
const GameStateScript := preload("res://domain/state/game_state.gd")
const GameModeScript := preload("res://domain/state/game_mode.gd")


func run() -> bool:
	if not _start_selects_first_line_and_sets_dialogue():
		return false
	if not _advance_to_second_line_stays_in_dialogue():
		return false
	if not _advancing_the_last_line_returns_exploration():
		return false
	return _advance_when_inactive_does_not_change_mode()


func _start_selects_first_line_and_sets_dialogue() -> bool:
	var lines: Array = OldManConversationScript.lines()
	var state := _session()
	var controller := _controller()
	controller.call("start", state, OldManConversationScript.ID)
	if state.get("mode").get("id") != GameModeScript.DIALOGUE:
		return false
	if not _same_line(controller.call("current_line"), lines[0]):
		return false
	return _narrative_unchanged(state)


func _advance_to_second_line_stays_in_dialogue() -> bool:
	var lines: Array = OldManConversationScript.lines()
	var state := _session()
	var controller := _controller()
	controller.call("start", state, OldManConversationScript.ID)
	controller.call("advance", state)
	if state.get("mode").get("id") != GameModeScript.DIALOGUE:
		return false
	if not _same_line(controller.call("current_line"), lines[1]):
		return false
	return _narrative_unchanged(state)


func _advancing_the_last_line_returns_exploration() -> bool:
	var lines: Array = OldManConversationScript.lines()
	if lines.size() != 5:
		return false
	var state := _session()
	var controller := _controller()
	controller.call("start", state, OldManConversationScript.ID)
	for index in range(1, 5):
		controller.call("advance", state)
		if state.get("mode").get("id") != GameModeScript.DIALOGUE:
			return false
		if not _same_line(controller.call("current_line"), lines[index]):
			return false
	controller.call("advance", state)
	if controller.call("current_line") != null:
		return false
	if state.get("mode").get("id") != GameModeScript.EXPLORATION:
		return false
	if not _narrative_unchanged(state):
		return false
	controller.call("start", state, OldManConversationScript.ID)
	if state.get("mode").get("id") != GameModeScript.DIALOGUE:
		return false
	if not _same_line(controller.call("current_line"), lines[0]):
		return false
	return _narrative_unchanged(state)


func _advance_when_inactive_does_not_change_mode() -> bool:
	if not _inactive_advance_keeps(GameModeScript.EXPLORATION):
		return false
	if not _inactive_advance_keeps(GameModeScript.DIALOGUE):
		return false
	return _inactive_advance_keeps(GameModeScript.COMBAT)


func _inactive_advance_keeps(mode_id: StringName) -> bool:
	var state := _session()
	state.get("mode").set("id", mode_id)
	var controller := _controller()
	controller.call("advance", state)
	if controller.call("current_line") != null:
		return false
	if state.get("mode").get("id") != mode_id:
		return false
	return _narrative_unchanged(state)


func _controller() -> RefCounted:
	return DialogueControllerScript.new()


func _session() -> RefCounted:
	var state: RefCounted = GameStateScript.new()
	state.get("mode").set("id", GameModeScript.EXPLORATION)
	state.get("world").call("set_flag", &"kept_flag", true)
	state.set("mission", "kept_mission")
	return state


func _narrative_unchanged(state: RefCounted) -> bool:
	if state.get("mission") != "kept_mission":
		return false
	var flags: Dictionary = state.get("world").call("flags")
	return flags.size() == 1 and flags.get("kept_flag") == true


func _same_line(actual: Variant, expected: Variant) -> bool:
	if actual == null or expected == null:
		return false
	if actual.get("speaker") != expected.get("speaker"):
		return false
	return actual.get("text") == expected.get("text")
