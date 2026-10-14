extends CanvasLayer

## Practice-fight box. Reads combatant ids, hp, and the round result from CombatSession.
## The highlight starts on Attack. Up and down only move that highlight.
## This box does not calculate hit or damage and does not write PlayerState.


const DIM := Color(0.62, 0.58, 0.52, 1)
const LIT := Color(0.98, 0.9, 0.55, 1)

const _ACTIONS: Array[String] = [CombatRound.ATTACK, CombatRound.DEFEND, CombatRound.FLEE]
const _LABELS: Array[String] = ["Attack", "Defend", "Flee"]

var _index := 0

@onready var _root: Control = $Root
@onready var _player_line: Label = $Root/Margin/Column/PlayerLine
@onready var _pirate_line: Label = $Root/Margin/Column/PirateLine
@onready var _outcome: Label = $Root/Margin/Column/Outcome
@onready var _attack_marker: Label = $Root/Margin/Column/AttackRow/Marker
@onready var _attack: Label = $Root/Margin/Column/AttackRow/AttackLabel
@onready var _defend_marker: Label = $Root/Margin/Column/DefendRow/Marker
@onready var _defend: Label = $Root/Margin/Column/DefendRow/DefendLabel
@onready var _flee_marker: Label = $Root/Margin/Column/FleeRow/Marker
@onready var _flee: Label = $Root/Margin/Column/FleeRow/FleeLabel


func _ready() -> void:
	_attack.text = _LABELS[0]
	_defend.text = _LABELS[1]
	_flee.text = _LABELS[2]
	_paint()


func open(fight: CombatSession) -> void:
	_index = 0
	refresh(fight)


func refresh(fight: CombatSession) -> void:
	if fight == null:
		return
	var player := fight.player_combatant()
	var pirate := fight.practice_pirate()
	_player_line.text = _combatant_line(player)
	_pirate_line.text = _combatant_line(pirate)
	_outcome.text = fight.result()
	_root.visible = true
	_paint()


func close() -> void:
	_root.visible = false


func highlight_previous() -> void:
	_index = maxi(_index - 1, 0)
	_paint()


func highlight_next() -> void:
	_index = mini(_index + 1, _ACTIONS.size() - 1)
	_paint()


func selected_action() -> String:
	return _ACTIONS[_index]


func _combatant_line(combatant: Combatant) -> String:
	if combatant == null:
		return ""
	return "%s  HP  %d" % [combatant.id, combatant.hp]


func _paint() -> void:
	var rows: Array[Dictionary] = [
		{"marker": _attack_marker, "label": _attack},
		{"marker": _defend_marker, "label": _defend},
		{"marker": _flee_marker, "label": _flee},
	]
	for row_index in rows.size():
		var selected := row_index == _index
		var marker: Label = rows[row_index]["marker"]
		var label: Label = rows[row_index]["label"]
		marker.text = ">" if selected else ""
		var color := LIT if selected else DIM
		marker.add_theme_color_override("font_color", color)
		label.add_theme_color_override("font_color", color)
