extends CanvasLayer

@onready var medallion_label: Label = $MarginContainer/VBox/TopBar/MedallionLabel
@onready var prompt_label: Label = $MarginContainer/VBox/PromptLabel
@onready var inventory_panel: Control = $InventoryPanel


func _ready() -> void:
	GameManager.medallion_changed.connect(_update_medallion_label)
	_update_medallion_label()


func _process(_delta: float) -> void:
	var player := get_tree().get_first_node_in_group("player")
	if player == null:
		prompt_label.visible = false
		return

	if inventory_panel.is_open():
		prompt_label.visible = false
		return

	if player.nearby_interactable != null:
		prompt_label.text = player.nearby_interactable.prompt_text
		prompt_label.visible = true
	else:
		prompt_label.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		inventory_panel.toggle_panel()
		_sync_player_movement()


func _sync_player_movement() -> void:
	var player := get_tree().get_first_node_in_group("player")
	if player != null:
		player.set_movement_enabled(not inventory_panel.is_open())


func _update_medallion_label() -> void:
	medallion_label.text = "Medalhão: %d/3" % GameManager.get_medallion_count()


func _on_save_exit_pressed() -> void:
	var player := get_tree().get_first_node_in_group("player")
	if player != null:
		GameManager.player_position = player.global_position
	GameManager.save_and_return_to_menu()
