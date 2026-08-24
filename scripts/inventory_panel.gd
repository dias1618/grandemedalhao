extends Control

const PART_IDS := ["parte_1", "parte_2", "parte_3"]
const PART_NAMES := ["Parte 1", "Parte 2", "Parte 3"]

@onready var panel: PanelContainer = $Panel
@onready var slots_container: HBoxContainer = $Panel/MarginContainer/VBox/Slots


func _ready() -> void:
	visible = true
	panel.visible = false
	GameManager.medallion_changed.connect(refresh_slots)
	_build_slots()
	refresh_slots()


func toggle_panel() -> void:
	panel.visible = not panel.visible


func is_open() -> bool:
	return panel.visible


func refresh_slots() -> void:
	for i in slots_container.get_child_count():
		var slot: PanelContainer = slots_container.get_child(i)
		var icon: ColorRect = slot.get_node("VBox/Icon")
		var label: Label = slot.get_node("VBox/NameLabel")
		if icon == null or label == null:
			continue
		var collected := GameManager.has_part(PART_IDS[i])
		icon.color = Color(0.85, 0.7, 0.15) if collected else Color(0.35, 0.35, 0.35)
		label.text = PART_NAMES[i] if collected else "%s (?)" % PART_NAMES[i]


func _build_slots() -> void:
	for i in PART_IDS.size():
		var slot := PanelContainer.new()
		slot.custom_minimum_size = Vector2(140, 160)

		var vbox := VBoxContainer.new()
		vbox.name = "VBox"
		vbox.alignment = BoxContainer.ALIGNMENT_CENTER

		var icon := ColorRect.new()
		icon.custom_minimum_size = Vector2(64, 64)
		icon.name = "Icon"
		icon.color = Color(0.35, 0.35, 0.35)

		var name_label := Label.new()
		name_label.name = "NameLabel"
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_label.text = "%s (?)" % PART_NAMES[i]

		vbox.add_child(icon)
		vbox.add_child(name_label)
		slot.add_child(vbox)
		slots_container.add_child(slot)
