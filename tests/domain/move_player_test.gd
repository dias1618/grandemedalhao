extends RefCounted

const MovePlayerScript := preload("res://application/movement/move_player.gd")
const PlayerStateScript := preload("res://domain/state/player_state.gd")
const GameModeScript := preload("res://domain/state/game_mode.gd")
const InputFrameScript := preload("res://application/input/input_frame.gd")
const InputActionScript := preload("res://application/input/input_action.gd")


func run() -> bool:
	if not _move_right_while_exploring_changes_position_and_direction():
		return false
	if not _zero_delta_does_not_move():
		return false
	if not _dialogue_ignores_move_actions():
		return false
	if not _combat_leaves_position_unchanged():
		return false
	if not _choice_and_pause_leave_position_unchanged():
		return false
	if not _main_menu_leaves_position_unchanged():
		return false
	if not _run_covers_more_distance_than_walk():
		return false
	if not _diagonal_is_not_faster_than_orthogonal():
		return false
	if not _player_speed_stat_does_not_change_distance():
		return false
	if not _open_blocker_still_moves_through_open_space():
		return false
	return _blocked_destination_keeps_position_and_release_does_not_slide()


func _move_right_while_exploring_changes_position_and_direction() -> bool:
	var player := _player_at(Vector2(10, 4), "down")
	var result: Dictionary = MovePlayerScript.step(player, _mode(GameModeScript.EXPLORATION), _frame([InputActionScript.MOVE_RIGHT]), 0.5)
	if player.get("direction") != "right":
		return false
	if result["direction"] != "right":
		return false
	var position: Vector2 = player.get("position")
	if position.x <= 10.0 or position.y != 4.0:
		return false
	return result["position"] == position


func _zero_delta_does_not_move() -> bool:
	var player := _player_at(Vector2(3, 4), "down")
	var result: Dictionary = MovePlayerScript.step(player, _mode(GameModeScript.EXPLORATION), _frame([InputActionScript.MOVE_RIGHT, InputActionScript.RUN]), 0.0)
	if player.get("position") != Vector2(3, 4):
		return false
	if player.get("direction") != "down":
		return false
	return result["position"] == Vector2(3, 4) and result["direction"] == "down"


func _dialogue_ignores_move_actions() -> bool:
	return _blocked_mode_keeps_state(GameModeScript.DIALOGUE)


func _combat_leaves_position_unchanged() -> bool:
	return _blocked_mode_keeps_state(GameModeScript.COMBAT)


func _choice_and_pause_leave_position_unchanged() -> bool:
	if not _blocked_mode_keeps_state(GameModeScript.CHOICE):
		return false
	return _blocked_mode_keeps_state(GameModeScript.PAUSE)


func _main_menu_leaves_position_unchanged() -> bool:
	return _blocked_mode_keeps_state(GameModeScript.MAIN_MENU)


func _run_covers_more_distance_than_walk() -> bool:
	var walked := _distance([InputActionScript.MOVE_RIGHT], 0.5)
	var ran := _distance([InputActionScript.MOVE_RIGHT, InputActionScript.RUN], 0.5)
	return ran > walked


func _diagonal_is_not_faster_than_orthogonal() -> bool:
	var orthogonal := _distance([InputActionScript.MOVE_RIGHT], 1.0)
	var diagonal := _distance([InputActionScript.MOVE_RIGHT, InputActionScript.MOVE_UP], 1.0)
	if diagonal > orthogonal + 0.001:
		return false
	return is_equal_approx(diagonal, orthogonal)


func _player_speed_stat_does_not_change_distance() -> bool:
	var slow := _player_at(Vector2.ZERO, "down")
	slow.set("speed", 1)
	var fast := _player_at(Vector2.ZERO, "down")
	fast.set("speed", 999)
	var frame := _frame([InputActionScript.MOVE_RIGHT])
	var delta := 0.25
	MovePlayerScript.step(slow, _mode(GameModeScript.EXPLORATION), frame, delta)
	MovePlayerScript.step(fast, _mode(GameModeScript.EXPLORATION), frame, delta)
	return is_equal_approx(slow.get("position").x, fast.get("position").x)


func _blocked_mode_keeps_state(mode_id: StringName) -> bool:
	var player := _player_at(Vector2(8, -2), "left")
	var result: Dictionary = MovePlayerScript.step(
		player,
		_mode(mode_id),
		_frame([InputActionScript.MOVE_RIGHT, InputActionScript.MOVE_UP, InputActionScript.RUN]),
		1.0
	)
	if player.get("position") != Vector2(8, -2):
		return false
	if player.get("direction") != "left":
		return false
	return result["position"] == Vector2(8, -2) and result["direction"] == "left"


func _distance(actions: Array, delta: float) -> float:
	var player := _player_at(Vector2.ZERO, "down")
	MovePlayerScript.step(player, _mode(GameModeScript.EXPLORATION), _frame(actions), delta)
	return player.get("position").length()


func _open_blocker_still_moves_through_open_space() -> bool:
	var player := _player_at(Vector2(10, 4), "down")
	var blocker := {
		"bounds": Rect2(-200, -200, 400, 400),
		"solids": [Rect2(400, 400, 20, 20)],
	}
	MovePlayerScript.step(player, _mode(GameModeScript.EXPLORATION), _frame([InputActionScript.MOVE_RIGHT]), 0.5, blocker)
	var position: Vector2 = player.get("position")
	return position.x > 10.0 and position.y == 4.0


func _blocked_destination_keeps_position_and_release_does_not_slide() -> bool:
	var start := Vector2(0, 0)
	var player := _player_at(start, "down")
	var blocker := {
		"bounds": Rect2(-200, -200, 400, 400),
		"solids": [Rect2(140, -20, 40, 40)],
	}
	var mode := _mode(GameModeScript.EXPLORATION)
	var blocked: Dictionary = MovePlayerScript.step(
		player,
		mode,
		_frame([InputActionScript.MOVE_RIGHT]),
		1.0,
		blocker
	)
	if player.get("position") != start:
		return false
	if blocked["position"] != start:
		return false
	var released: Dictionary = MovePlayerScript.step(player, mode, _frame([]), 1.0, blocker)
	if player.get("position") != start:
		return false
	return released["position"] == start


func _player_at(position: Vector2, direction: String) -> RefCounted:
	var player := PlayerStateScript.new()
	player.set("position", position)
	player.set("direction", direction)
	return player


func _mode(mode_id: StringName) -> RefCounted:
	return GameModeScript.create(mode_id)


func _frame(actions: Array) -> RefCounted:
	var frame := InputFrameScript.new()
	for action in actions:
		frame.call("set_held", action, true)
	return frame
