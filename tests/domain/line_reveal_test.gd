extends RefCounted

const LineRevealScript := preload("res://application/dialogue/line_reveal.gd")
const DialogueLineScript := preload("res://domain/dialogue/dialogue_line.gd")


func run() -> bool:
	if not _incomplete_confirm_completes_without_advance():
		return false
	if not _complete_confirm_requests_advance():
		return false
	return _confirm_without_a_line_does_nothing()


func _incomplete_confirm_completes_without_advance() -> bool:
	var reveal := _reveal()
	reveal.call("begin", _line())
	var decision: StringName = reveal.call("confirm")
	if decision != LineRevealScript.COMPLETE:
		return false
	if not reveal.call("is_complete"):
		return false
	return reveal.call("confirm") == LineRevealScript.ADVANCE


func _complete_confirm_requests_advance() -> bool:
	var reveal := _reveal()
	reveal.call("begin", _line())
	reveal.call("finish_reveal")
	if not reveal.call("is_complete"):
		return false
	if reveal.call("confirm") != LineRevealScript.ADVANCE:
		return false
	reveal.call("begin", _line())
	if reveal.call("is_complete"):
		return false
	return reveal.call("confirm") == LineRevealScript.COMPLETE


func _confirm_without_a_line_does_nothing() -> bool:
	var reveal := _reveal()
	if reveal.call("confirm") != LineRevealScript.NONE:
		return false
	if reveal.call("is_complete"):
		return false
	reveal.call("begin", null)
	if reveal.call("confirm") != LineRevealScript.NONE:
		return false
	if reveal.call("is_complete"):
		return false
	reveal.call("begin", _line())
	reveal.call("finish_reveal")
	reveal.call("begin", null)
	if reveal.call("is_complete"):
		return false
	return reveal.call("confirm") == LineRevealScript.NONE


func _reveal() -> RefCounted:
	return LineRevealScript.new()


func _line() -> RefCounted:
	return DialogueLineScript.create("old_man", "texto", "normal", "old_man")
