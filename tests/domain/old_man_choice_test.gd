extends RefCounted

const ResolveOldManChoiceScript := preload("res://application/choice/resolve_old_man_choice.gd")
const DialogueControllerScript := preload("res://application/dialogue/dialogue_controller.gd")
const OldManConversationScript := preload("res://domain/dialogue/old_man_conversation.gd")
const OldManHelpChoiceScript := preload("res://domain/choice/old_man_help_choice.gd")
const MissionStateScript := preload("res://domain/mission/mission_state.gd")
const GameStateScript := preload("res://domain/state/game_state.gd")
const GameModeScript := preload("res://domain/state/game_mode.gd")


func run() -> bool:
	if not _ending_not_started_opens_choice_and_accept_starts_first_line():
		return false
	if not _refuse_leaves_mission_null_and_reply_returns_exploration():
		return false
	if not _accept_when_already_accepted_does_not_change_stage():
		return false
	if not _ending_when_accepted_stays_exploration():
		return false
	if not _refuse_when_accepted_does_not_revert():
		return false
	if not _unknown_option_changes_nothing():
		return false
	return _ending_reply_does_not_reopen_choice()


func _ending_not_started_opens_choice_and_accept_starts_first_line() -> bool:
	var state := _session()
	var controller := _play_conversation(state)
	if state.get("mode").get("id") != GameModeScript.EXPLORATION:
		return false
	if state.get("mission") != null:
		return false
	ResolveOldManChoiceScript.offer(state)
	if state.get("mode").get("id") != GameModeScript.CHOICE:
		return false
	if not _flags_kept(state):
		return false
	ResolveOldManChoiceScript.select(state, controller, OldManHelpChoiceScript.ACCEPT)
	if state.get("mode").get("id") != GameModeScript.DIALOGUE:
		return false
	if not _mission_accepted(state.get("mission")):
		return false
	if not _same_line(controller.call("current_line"), OldManHelpChoiceScript.lines_for("accept")[0]):
		return false
	for _index in range(3):
		controller.call("advance", state)
	if state.get("mode").get("id") != GameModeScript.EXPLORATION:
		return false
	if controller.call("current_line") != null:
		return false
	if not _mission_accepted(state.get("mission")):
		return false
	return _flags_kept(state)


func _refuse_leaves_mission_null_and_reply_returns_exploration() -> bool:
	var state := _session()
	var controller := _play_conversation(state)
	ResolveOldManChoiceScript.offer(state)
	if state.get("mode").get("id") != GameModeScript.CHOICE:
		return false
	ResolveOldManChoiceScript.select(state, controller, OldManHelpChoiceScript.REFUSE)
	if state.get("mission") != null:
		return false
	if state.get("mode").get("id") != GameModeScript.DIALOGUE:
		return false
	var lines: Array = OldManHelpChoiceScript.lines_for("refuse")
	if lines.size() != 1 or not _same_line(controller.call("current_line"), lines[0]):
		return false
	controller.call("advance", state)
	if state.get("mode").get("id") != GameModeScript.EXPLORATION:
		return false
	if controller.call("current_line") != null:
		return false
	if state.get("mission") != null:
		return false
	return _flags_kept(state)


func _accept_when_already_accepted_does_not_change_stage() -> bool:
	var state := _session()
	var accepted: Variant = MissionStateScript.create(MissionStateScript.ACCEPTED)
	state.set("mission", accepted)
	var controller := _play_conversation(state)
	ResolveOldManChoiceScript.offer(state)
	if state.get("mode").get("id") != GameModeScript.EXPLORATION:
		return false
	if state.get("mission") != accepted:
		return false
	ResolveOldManChoiceScript.select(state, controller, OldManHelpChoiceScript.ACCEPT)
	if state.get("mode").get("id") != GameModeScript.EXPLORATION:
		return false
	if controller.call("current_line") != null:
		return false
	if state.get("mission") != accepted:
		return false
	if not _mission_accepted(state.get("mission")):
		return false
	return _flags_kept(state)


func _ending_when_accepted_stays_exploration() -> bool:
	var state := _session()
	var accepted: Variant = MissionStateScript.create(MissionStateScript.ACCEPTED)
	state.set("mission", accepted)
	_play_conversation(state)
	if state.get("mode").get("id") != GameModeScript.EXPLORATION:
		return false
	ResolveOldManChoiceScript.offer(state)
	if state.get("mode").get("id") != GameModeScript.EXPLORATION:
		return false
	if state.get("mission") != accepted:
		return false
	return _mission_accepted(accepted)


func _refuse_when_accepted_does_not_revert() -> bool:
	var state := _session()
	var accepted: Variant = MissionStateScript.create(MissionStateScript.ACCEPTED)
	state.set("mission", accepted)
	state.get("mode").set("id", GameModeScript.CHOICE)
	var controller := _controller()
	ResolveOldManChoiceScript.select(state, controller, OldManHelpChoiceScript.REFUSE)
	if state.get("mode").get("id") != GameModeScript.CHOICE:
		return false
	if controller.call("current_line") != null:
		return false
	if state.get("mission") != accepted:
		return false
	return _mission_accepted(accepted)


func _unknown_option_changes_nothing() -> bool:
	var state := _session()
	var controller := _controller()
	ResolveOldManChoiceScript.offer(state)
	if state.get("mode").get("id") != GameModeScript.CHOICE:
		return false
	ResolveOldManChoiceScript.select(state, controller, "cave")
	if state.get("mode").get("id") != GameModeScript.CHOICE:
		return false
	if state.get("mission") != null:
		return false
	if controller.call("current_line") != null:
		return false
	ResolveOldManChoiceScript.select(state, controller, "")
	if state.get("mode").get("id") != GameModeScript.CHOICE:
		return false
	return state.get("mission") == null and _flags_kept(state)


func _ending_reply_does_not_reopen_choice() -> bool:
	var refused := _session()
	var refused_lines := _play_conversation(refused)
	ResolveOldManChoiceScript.offer(refused)
	ResolveOldManChoiceScript.select(refused, refused_lines, OldManHelpChoiceScript.REFUSE)
	refused_lines.call("advance", refused)
	if refused.get("mode").get("id") != GameModeScript.EXPLORATION:
		return false
	if refused.get("mission") != null:
		return false
	refused_lines.call("advance", refused)
	if refused.get("mode").get("id") != GameModeScript.EXPLORATION:
		return false
	_play_conversation(refused)
	if refused.get("mode").get("id") != GameModeScript.EXPLORATION:
		return false
	ResolveOldManChoiceScript.offer(refused)
	if refused.get("mode").get("id") != GameModeScript.CHOICE:
		return false
	if refused.get("mission") != null:
		return false

	var accepted := _session()
	var accepted_lines := _play_conversation(accepted)
	ResolveOldManChoiceScript.offer(accepted)
	ResolveOldManChoiceScript.select(accepted, accepted_lines, OldManHelpChoiceScript.ACCEPT)
	for _index in range(3):
		accepted_lines.call("advance", accepted)
	if accepted.get("mode").get("id") != GameModeScript.EXPLORATION:
		return false
	ResolveOldManChoiceScript.offer(accepted)
	if accepted.get("mode").get("id") != GameModeScript.EXPLORATION:
		return false
	_play_conversation(accepted)
	ResolveOldManChoiceScript.offer(accepted)
	if accepted.get("mode").get("id") != GameModeScript.EXPLORATION:
		return false
	if not _mission_accepted(accepted.get("mission")):
		return false
	return _flags_kept(refused) and _flags_kept(accepted)


func _play_conversation(state: RefCounted) -> RefCounted:
	var lines: Array = OldManConversationScript.lines()
	var controller := _controller()
	controller.call("start", state, OldManConversationScript.ID)
	for index in range(1, lines.size()):
		controller.call("advance", state)
	controller.call("advance", state)
	return controller


func _controller() -> RefCounted:
	return DialogueControllerScript.new()


func _session() -> RefCounted:
	var state: RefCounted = GameStateScript.new()
	state.get("mode").set("id", GameModeScript.EXPLORATION)
	state.get("world").call("set_flag", &"kept_flag", true)
	return state


func _mission_accepted(mission: Variant) -> bool:
	if mission == null:
		return false
	if mission.get("id") != MissionStateScript.ID:
		return false
	return MissionStateScript.stage_of(mission) == MissionStateScript.ACCEPTED


func _flags_kept(state: RefCounted) -> bool:
	var flags: Dictionary = state.get("world").call("flags")
	return flags.size() == 1 and flags.get("kept_flag") == true


func _same_line(actual: Variant, expected: Variant) -> bool:
	if actual == null or expected == null:
		return false
	if actual.get("speaker") != expected.get("speaker"):
		return false
	return actual.get("text") == expected.get("text")
