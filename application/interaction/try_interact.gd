class_name TryInteract
extends RefCounted

## Resolves one interact press into a conversation id.
## Succeeds only in exploration, in the bar, within old_man's range.
## Any other press returns an empty string and changes nothing.
## An empty string means no target. This use case does not start dialogue.


const InteractionTargetScript := preload("res://domain/interaction/interaction_target.gd")


static func execute(state: GameState, frame: InputFrame) -> String:
	if state == null or frame == null:
		return ""
	if not frame.is_just_pressed(InputAction.INTERACT):
		return ""
	if state.mode == null or state.mode.id != GameMode.EXPLORATION:
		return ""
	if state.current_scene_id != "bar":
		return ""
	var target: InteractionTarget = InteractionTargetScript.old_man()
	if not target.contains(state.player.position):
		return ""
	return target.conversation_id
