extends RefCounted

const BlockedMovementScript := preload("res://domain/movement/blocked_movement.gd")


func run() -> bool:
	if not _open_space_is_accepted():
		return false
	if not _far_edge_is_accepted():
		return false
	if not _one_unit_past_far_edge_is_rejected():
		return false
	if not _outside_the_near_edge_is_rejected():
		return false
	return _overlapping_a_solid_is_rejected()


func _open_space_is_accepted() -> bool:
	return BlockedMovementScript.allows(Vector2(40, 30), _playable(), [_crate()])


func _far_edge_is_accepted() -> bool:
	var bounds := _playable()
	var far_edge := Vector2(bounds.position.x + bounds.size.x, 30)
	return BlockedMovementScript.allows(far_edge, bounds, [])


func _one_unit_past_far_edge_is_rejected() -> bool:
	var bounds := _playable()
	var past := Vector2(bounds.position.x + bounds.size.x + 1.0, 30)
	return not BlockedMovementScript.allows(past, bounds, [])


func _outside_the_near_edge_is_rejected() -> bool:
	return not BlockedMovementScript.allows(Vector2(-1, 30), _playable(), [])


func _overlapping_a_solid_is_rejected() -> bool:
	var crate := _crate()
	var inside := crate.position + crate.size * 0.5
	if BlockedMovementScript.allows(inside, _playable(), [crate]):
		return false
	var beside := Vector2(crate.position.x - 1.0, inside.y)
	return BlockedMovementScript.allows(beside, _playable(), [crate])


func _playable() -> Rect2:
	return Rect2(0, 0, 100, 80)


func _crate() -> Rect2:
	return Rect2(10, 10, 20, 20)
