class_name InputAction
extends RefCounted

## Closed set of player actions. Gameplay asks for these names, not for keys.


const MOVE_UP := &"move_up"
const MOVE_DOWN := &"move_down"
const MOVE_LEFT := &"move_left"
const MOVE_RIGHT := &"move_right"
const INTERACT := &"interact"
const RUN := &"run"
const CONFIRM := &"confirm"
const BACK := &"back"
const PAUSE := &"pause"

const VALUES: Array[StringName] = [
	MOVE_UP,
	MOVE_DOWN,
	MOVE_LEFT,
	MOVE_RIGHT,
	INTERACT,
	RUN,
	CONFIRM,
	BACK,
	PAUSE,
]


static func is_known(action: StringName) -> bool:
	return action in VALUES
