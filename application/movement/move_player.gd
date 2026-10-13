class_name MovePlayer
extends RefCounted

## One movement step from a player, a mode, an input frame, and a delta.
## Walk and run speeds live here. PlayerState.speed is a combat stat and is not used.
## Does not read Input or call move_and_slide.
## blocker may carry "bounds" (Rect2) and "solids" (Array of Rect2).
## An empty dictionary does not constrain the step.
## A rejected destination leaves PlayerState.position on the last accepted point.


const WALK_SPEED := 160.0
const RUN_SPEED := 280.0


static func step(
	player: PlayerState,
	mode: GameMode,
	frame: InputFrame,
	delta: float,
	blocker: Dictionary = {}
) -> Dictionary:
	var position: Vector2 = player.position
	var direction: String = player.direction
	if mode == null or mode.id != GameMode.EXPLORATION:
		return {"position": position, "direction": direction}
	var axis := _axis(frame)
	if axis == Vector2.ZERO or delta == 0.0:
		return {"position": position, "direction": direction}
	direction = _facing(axis)
	var speed := WALK_SPEED
	if frame.is_held(InputAction.RUN):
		speed = RUN_SPEED
	var desired := position + axis * speed * delta
	if _is_blocked(desired, blocker):
		player.direction = direction
		return {"position": position, "direction": direction}
	player.position = desired
	player.direction = direction
	return {"position": desired, "direction": direction}


static func _is_blocked(desired: Vector2, blocker: Dictionary) -> bool:
	if not blocker.has("bounds"):
		return false
	var bounds: Rect2 = blocker["bounds"]
	var solids: Array = blocker.get("solids", [])
	return not BlockedMovement.allows(desired, bounds, solids)


static func _axis(frame: InputFrame) -> Vector2:
	var axis := Vector2.ZERO
	if frame.is_held(InputAction.MOVE_RIGHT):
		axis.x += 1.0
	if frame.is_held(InputAction.MOVE_LEFT):
		axis.x -= 1.0
	if frame.is_held(InputAction.MOVE_DOWN):
		axis.y += 1.0
	if frame.is_held(InputAction.MOVE_UP):
		axis.y -= 1.0
	if axis == Vector2.ZERO:
		return axis
	return axis.normalized()


## Horizontal facing wins when both axes are held, so a diagonal still stores one of the four directions.
static func _facing(axis: Vector2) -> String:
	if absf(axis.x) >= absf(axis.y):
		return "right" if axis.x > 0.0 else "left"
	return "down" if axis.y > 0.0 else "up"
