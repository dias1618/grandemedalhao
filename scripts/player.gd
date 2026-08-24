extends CharacterBody2D

const SPEED := 120.0

var movement_enabled := true
var nearby_interactable: Interactable = null

@onready var interact_detector: Area2D = $InteractDetector


func _ready() -> void:
	add_to_group("player")
	collision_layer = 2
	collision_mask = 1
	interact_detector.area_entered.connect(_on_interact_detector_area_entered)
	interact_detector.area_exited.connect(_on_interact_detector_area_exited)


func _physics_process(_delta: float) -> void:
	if not movement_enabled:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var input_dir := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)

	if input_dir.length() > 0.0:
		input_dir = input_dir.normalized()

	velocity = input_dir * SPEED
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if not movement_enabled:
		return
	if event.is_action_pressed("interact") and nearby_interactable != null:
		nearby_interactable.try_interact(self)


func set_movement_enabled(enabled: bool) -> void:
	movement_enabled = enabled
	if not enabled:
		velocity = Vector2.ZERO


func _on_interact_detector_area_entered(area: Area2D) -> void:
	if area is Interactable:
		nearby_interactable = area


func _on_interact_detector_area_exited(area: Area2D) -> void:
	if area == nearby_interactable:
		nearby_interactable = null
