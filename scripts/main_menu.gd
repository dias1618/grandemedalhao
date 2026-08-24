extends Control

@onready var load_button: Button = $Panel/VBox/LoadButton


func _ready() -> void:
	load_button.disabled = not GameManager.has_save()


func _on_new_game_pressed() -> void:
	GameManager.start_new_game()


func _on_load_game_pressed() -> void:
	if not GameManager.load_game():
		load_button.disabled = true
