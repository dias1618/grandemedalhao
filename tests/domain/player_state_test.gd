extends RefCounted

const PlayerStateScript := preload("res://domain/state/player_state.gd")
const GameStateScript := preload("res://domain/state/game_state.gd")


func run() -> bool:
	if not _stores_initial_protagonist():
		return false
	if not _position_update_replaces_previous_vector():
		return false
	if not _scene_id_can_change():
		return false
	if not _empty_character_id_is_rejected():
		return false
	if not _direction_accepts_only_four_facings():
		return false
	if not _game_state_player_is_independent_of_current_scene():
		return false
	return true


func _stores_initial_protagonist() -> bool:
	var player: RefCounted = PlayerStateScript.new()
	if player.get("character_id") != "zoro":
		return false
	if player.get("position") != Vector2.ZERO:
		return false
	if player.get("scene_id") != "":
		return false
	if player.get("direction") != "down":
		return false
	if player.get("hp") != 10:
		return false
	if player.get("energy") != 10:
		return false
	if player.get("strength") != 10:
		return false
	if player.get("defense") != 10:
		return false
	if player.get("speed") != 10:
		return false
	if player.get("luck") != 10:
		return false
	return true


func _position_update_replaces_previous_vector() -> bool:
	var player: RefCounted = PlayerStateScript.new()
	player.set("position", Vector2(1, 2))
	player.set("position", Vector2(8, -3))
	return player.get("position") == Vector2(8, -3)


func _scene_id_can_change() -> bool:
	var player: RefCounted = PlayerStateScript.new()
	player.set("scene_id", "bar")
	if player.get("scene_id") != "bar":
		return false
	player.set("scene_id", "cave")
	return player.get("scene_id") == "cave"


func _empty_character_id_is_rejected() -> bool:
	var player: RefCounted = PlayerStateScript.new()
	player.set("character_id", "custom")
	player.set("character_id", "")
	return player.get("character_id") == "custom"


func _direction_accepts_only_four_facings() -> bool:
	var player: RefCounted = PlayerStateScript.new()
	for facing in ["up", "down", "left", "right"]:
		player.set("direction", facing)
		if player.get("direction") != facing:
			return false
	player.set("direction", "north")
	return player.get("direction") == "right"


func _game_state_player_is_independent_of_current_scene() -> bool:
	var session: RefCounted = GameStateScript.new()
	var player: Variant = session.get("player")
	if player == null or player.get_script() != PlayerStateScript:
		return false
	if player.get("character_id") != "zoro":
		return false
	player.set("scene_id", "bar")
	if session.get("current_scene_id") != "":
		return false
	session.set("current_scene_id", "cave")
	return player.get("scene_id") == "bar"
