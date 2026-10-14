class_name DialogueController
extends RefCounted

## Plays old_man_conversation by reading OldManConversation.
## Start selects the first line and sets the mode to dialogue.
## start_reply selects the first line returned by OldManHelpChoice.lines_for.
## Each advance follows next. Leaving the last line clears the line and sets exploration.
## Advance while no line is selected leaves the mode unchanged.
## Does not write world flags or mission, and does not draw a box.


var _current: DialogueLine = null


func start(state: GameState, conversation_id: String) -> void:
	if state == null or state.mode == null:
		return
	if conversation_id != OldManConversation.ID:
		return
	var sequence := OldManConversation.lines()
	if sequence.is_empty():
		return
	_current = sequence[0]
	state.mode.id = GameMode.DIALOGUE


func start_reply(state: GameState, option_id: String) -> void:
	if state == null or state.mode == null:
		return
	var sequence := OldManHelpChoice.lines_for(option_id)
	if sequence.is_empty():
		return
	_current = sequence[0]
	state.mode.id = GameMode.DIALOGUE


func advance(state: GameState) -> void:
	if _current == null or state == null or state.mode == null:
		return
	_current = _current.next
	if _current == null:
		state.mode.id = GameMode.EXPLORATION


func current_line() -> DialogueLine:
	return _current
