extends Node2D

const PLAYER_SCENE := preload("res://scenes/player/player.tscn")
const HUD_SCENE := preload("res://scenes/ui/hud.tscn")

@onready var player_spawn: Marker2D = $PlayerSpawn
@onready var exit_area: Area2D = $ExitArea


func _ready() -> void:
	_spawn_player()
	_add_hud()
	exit_area.body_entered.connect(_on_exit_area_body_entered)


func _spawn_player() -> void:
	var player := PLAYER_SCENE.instantiate()
	player.global_position = player_spawn.global_position
	add_child(player)


func _add_hud() -> void:
	var hud := HUD_SCENE.instantiate()
	add_child(hud)


func _on_exit_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameManager.exit_house()
