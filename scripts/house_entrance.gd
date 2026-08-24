class_name HouseEntrance
extends Interactable

@export var house_id: String = "casa_1"


func _ready() -> void:
	super._ready()
	prompt_text = "Pressione E para entrar"
	auto_interact = false
	interacted.connect(_on_interacted)


func _on_interacted(body: Node2D) -> void:
	GameManager.enter_house(house_id, body.global_position)
