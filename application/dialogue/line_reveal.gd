class_name LineReveal
extends RefCounted

## Complete-or-advance rule for the line on screen.
## Confirm on an incomplete line completes it and does not ask to advance.
## Confirm on a complete line asks to advance.
## Confirm with no active line neither completes the text nor asks to advance.
## Does not instance a scene or read Input.


const COMPLETE := &"complete"
const ADVANCE := &"advance"
const NONE := &"none"

var _active := false
var _complete := false


func begin(line: DialogueLine) -> void:
	_active = line != null
	_complete = false


func finish_reveal() -> void:
	if _active:
		_complete = true


func is_complete() -> bool:
	return _active and _complete


func confirm() -> StringName:
	if not _active:
		return NONE
	if not _complete:
		_complete = true
		return COMPLETE
	return ADVANCE
