class_name GameState
extends RefCounted

## Session aggregate. Party and mission stay empty until later units.


var player: PlayerState
var world: WorldState
var mode: GameMode
var party: Variant = null
var mission: Variant = null
var current_scene_id: String = ""
var save_metadata: Dictionary = {}


func _init() -> void:
	player = PlayerState.new()
	world = WorldState.new()
	mode = GameMode.create(GameMode.MAIN_MENU)
	save_metadata = {}
