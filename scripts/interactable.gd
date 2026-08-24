class_name Interactable
extends Area2D

signal player_entered(body: Node2D)
signal player_exited(body: Node2D)
signal interacted(body: Node2D)

@export var prompt_text: String = "Pressione E para interagir"
@export var auto_interact: bool = false

var _player_inside: Node2D = null


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	collision_layer = 4
	collision_mask = 2
	monitoring = true
	monitorable = false


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	_player_inside = body
	player_entered.emit(body)
	if auto_interact:
		try_interact(body)


func _on_body_exited(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	if _player_inside == body:
		_player_inside = null
	player_exited.emit(body)


func try_interact(body: Node2D = null) -> void:
	var target := body if body != null else _player_inside
	if target == null:
		return
	interacted.emit(target)


func has_player_inside() -> bool:
	return _player_inside != null
