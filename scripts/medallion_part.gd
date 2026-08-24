class_name MedallionPart
extends Interactable

@export var part_id: String = "parte_1"
@export var part_label: String = "Parte 1"


func _ready() -> void:
	super._ready()
	prompt_text = "Pressione E para coletar"
	auto_interact = true
	interacted.connect(_on_interacted)

	if GameManager.has_part(part_id):
		queue_free()


func _on_interacted(_body: Node2D) -> void:
	if GameManager.collect_part(part_id):
		queue_free()
