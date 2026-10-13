class_name GameMode
extends RefCounted

## Closed set of session modes. Any listed mode may be assigned directly.
## This type does not define transitions, input, or UI.


const MAIN_MENU := &"main_menu"
const EXPLORATION := &"exploration"
const DIALOGUE := &"dialogue"
const CHOICE := &"choice"
const COMBAT := &"combat"
const PAUSE := &"pause"
const LOADING := &"loading"
const SAVING := &"saving"

const VALUES: Array[StringName] = [
	MAIN_MENU,
	EXPLORATION,
	DIALOGUE,
	CHOICE,
	COMBAT,
	PAUSE,
	LOADING,
	SAVING,
]

var id: StringName = MAIN_MENU:
	set(value):
		if value not in VALUES:
			return
		id = value


static func create(id: StringName) -> GameMode:
	if id not in VALUES:
		return null
	var mode := GameMode.new()
	mode.id = id
	return mode
