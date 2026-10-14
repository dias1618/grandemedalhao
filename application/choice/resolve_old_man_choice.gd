class_name ResolveOldManChoice
extends RefCounted

## Opens choice when old_man_conversation ends and the mission is not started.
## Accept from not_started stores old_man_daughter at accepted and starts the accept lines.
## Refuse from not_started leaves mission null and starts the refuse line.
## Accept or refuse from accepted does not change the stage.
## An unknown option changes neither mode nor mission.
## Reply text stays in OldManHelpChoice. World flags stay unchanged.
## Choice and dialogue are direct assignments. There is no transition table.


static func offer(state: GameState) -> void:
	if state == null or state.mode == null:
		return
	if MissionState.stage_of(state.mission) != MissionState.NOT_STARTED:
		return
	state.mode.id = GameMode.CHOICE


static func select(state: GameState, dialogue: DialogueController, option_id: String) -> void:
	if state == null or state.mode == null or dialogue == null:
		return
	if option_id != OldManHelpChoice.ACCEPT and option_id != OldManHelpChoice.REFUSE:
		return
	if MissionState.stage_of(state.mission) == MissionState.ACCEPTED:
		return
	if option_id == OldManHelpChoice.ACCEPT:
		state.mission = MissionState.create(MissionState.ACCEPTED)
	dialogue.start_reply(state, option_id)
