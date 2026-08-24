extends Node

const SaveData = preload("res://scripts/save_data.gd")

signal medallion_changed
signal save_changed

const VILLAGE_SCENE := "res://scenes/world/village.tscn"
const INTERIOR_SCENE := "res://scenes/interiors/house_interior.tscn"
const MENU_SCENE := "res://scenes/main_menu.tscn"

const HOUSE_SPAWN_POSITIONS := {
	"casa_1": Vector2(320, 280),
	"casa_2": Vector2(640, 280),
	"casa_3": Vector2(960, 280),
}

const DEFAULT_SPAWN := Vector2(640, 480)

var medallion_parts: Array[String] = []
var player_position: Vector2 = DEFAULT_SPAWN
var current_world: String = "village"
var current_house_id: String = ""


func _ready() -> void:
	pass


func reset_game() -> void:
	medallion_parts.clear()
	player_position = DEFAULT_SPAWN
	current_world = "village"
	current_house_id = ""
	medallion_changed.emit()
	save_changed.emit()


func has_save() -> bool:
	return SaveData.save_exists()


func collect_part(part_id: String) -> bool:
	if part_id in medallion_parts:
		return false
	if medallion_parts.size() >= 3:
		return false

	medallion_parts.append(part_id)
	medallion_changed.emit()
	auto_save()
	return true


func has_part(part_id: String) -> bool:
	return part_id in medallion_parts


func get_medallion_count() -> int:
	return medallion_parts.size()


func enter_house(house_id: String, player_pos: Vector2) -> void:
	current_house_id = house_id
	player_position = player_pos
	current_world = "interior"
	auto_save()
	get_tree().change_scene_to_file(INTERIOR_SCENE)


func exit_house() -> void:
	if current_house_id in HOUSE_SPAWN_POSITIONS:
		player_position = HOUSE_SPAWN_POSITIONS[current_house_id]
	else:
		player_position = DEFAULT_SPAWN

	current_world = "village"
	auto_save()
	get_tree().change_scene_to_file(VILLAGE_SCENE)


func start_new_game() -> void:
	reset_game()
	delete_save()
	get_tree().change_scene_to_file(VILLAGE_SCENE)


func load_game() -> bool:
	if not load_from_disk():
		return false

	if current_world == "interior":
		get_tree().change_scene_to_file(INTERIOR_SCENE)
	else:
		get_tree().change_scene_to_file(VILLAGE_SCENE)
	return true


func save_and_return_to_menu() -> void:
	auto_save()
	get_tree().change_scene_to_file(MENU_SCENE)


func auto_save() -> void:
	if is_inside_tree():
		var player := get_tree().get_first_node_in_group("player")
		if player != null:
			player_position = player.global_position

	var save := SaveData.new()
	save.medallion_parts = medallion_parts.duplicate()
	save.player_position = player_position
	save.current_world = current_world
	save.current_house_id = current_house_id
	_write_save(save)
	save_changed.emit()


func load_from_disk() -> bool:
	if not SaveData.save_exists():
		return false

	var file := FileAccess.open(SaveData.SAVE_PATH, FileAccess.READ)
	if file == null:
		return false

	var json := JSON.new()
	var error := json.parse(file.get_as_text())
	file.close()

	if error != OK:
		return false

	var save := SaveData.from_dict(json.data)
	medallion_parts = save.medallion_parts.duplicate()
	player_position = save.player_position
	current_world = save.current_world
	current_house_id = save.current_house_id
	medallion_changed.emit()
	save_changed.emit()
	return true


func delete_save() -> void:
	if SaveData.save_exists():
		DirAccess.remove_absolute(SaveData.SAVE_PATH)


func _write_save(save: SaveData) -> void:
	var file := FileAccess.open(SaveData.SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Não foi possível salvar em %s" % SaveData.SAVE_PATH)
		return

	file.store_string(JSON.stringify(save.to_dict(), "\t"))
