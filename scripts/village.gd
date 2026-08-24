extends Node2D

const PLAYER_SCENE := preload("res://scenes/player/player.tscn")
const HUD_SCENE := preload("res://scenes/ui/hud.tscn")

@onready var player_spawn: Marker2D = $PlayerSpawn
@onready var medallion_parts: Node2D = $MedallionParts


func _ready() -> void:
	_spawn_player()
	_setup_medallions()
	_add_hud()


func _spawn_player() -> void:
	var player := PLAYER_SCENE.instantiate()
	player.global_position = GameManager.player_position if GameManager.player_position != Vector2.ZERO else player_spawn.global_position
	add_child(player)


func _setup_medallions() -> void:
	for child in medallion_parts.get_children():
		if child is MedallionPart:
			if GameManager.has_part(child.part_id):
				child.queue_free()


func _add_hud() -> void:
	var hud := HUD_SCENE.instantiate()
	add_child(hud)
