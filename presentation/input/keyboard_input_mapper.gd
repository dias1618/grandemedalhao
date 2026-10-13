class_name KeyboardInputMapper
extends RefCounted

## Copies the engine input map into an InputFrame.
## This is the only script that calls the Input singleton.


static func read() -> InputFrame:
	var frame := InputFrame.new()
	for action in InputAction.VALUES:
		if Input.is_action_pressed(action):
			frame.set_held(action, true)
		if Input.is_action_just_pressed(action):
			frame.set_just_pressed(action, true)
	return frame
