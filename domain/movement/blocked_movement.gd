class_name BlockedMovement
extends RefCounted

## Axis-aligned rectangle data for a desired position.
## The playable rectangle includes every edge. A solid includes its own edges.
## This rule does not read scenes or physics bodies.


static func allows(position: Vector2, bounds: Rect2, solids: Array = []) -> bool:
	if not _contains(bounds, position):
		return false
	for solid in solids:
		if solid is Rect2 and _contains(solid, position):
			return false
	return true


static func _contains(rectangle: Rect2, position: Vector2) -> bool:
	var area := rectangle.abs()
	var far := area.position + area.size
	return position.x >= area.position.x \
		and position.x <= far.x \
		and position.y >= area.position.y \
		and position.y <= far.y
