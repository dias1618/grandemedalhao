class_name SaveData
extends RefCounted

const SAVE_PATH := "user://savegame.json"

var medallion_parts: Array[String] = []
var player_position: Vector2 = Vector2.ZERO
var current_world: String = "village"
var current_house_id: String = ""


static func save_exists() -> bool:
	return FileAccess.file_exists(SAVE_PATH)


func to_dict() -> Dictionary:
	return {
		"medallion_parts": medallion_parts,
		"player_position": {"x": player_position.x, "y": player_position.y},
		"current_world": current_world,
		"current_house_id": current_house_id,
	}


static func from_dict(data: Dictionary) -> SaveData:
	var save := SaveData.new()
	save.medallion_parts.assign(data.get("medallion_parts", []))

	var pos: Dictionary = data.get("player_position", {})
	save.player_position = Vector2(pos.get("x", 0.0), pos.get("y", 0.0))
	save.current_world = data.get("current_world", "village")
	save.current_house_id = data.get("current_house_id", "")
	return save
