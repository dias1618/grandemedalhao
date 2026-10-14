extends CanvasLayer

## Yes/no box. Reads the prompt and the two labels from OldManHelpChoice.
## The highlight starts on accept. Up and down only change that highlight.
## Confirm is routed by the session entry. This box does not apply the mission.


const DIM := Color(0.62, 0.58, 0.52, 1)
const LIT := Color(0.98, 0.9, 0.55, 1)

const _OPTIONS: Array[String] = [OldManHelpChoice.ACCEPT, OldManHelpChoice.REFUSE]

var _index := 0

@onready var _root: Control = $Root
@onready var _prompt: Label = $Root/Margin/Column/Prompt
@onready var _accept_marker: Label = $Root/Margin/Column/AcceptRow/Marker
@onready var _accept: Label = $Root/Margin/Column/AcceptRow/AcceptLabel
@onready var _refuse_marker: Label = $Root/Margin/Column/RefuseRow/Marker
@onready var _refuse: Label = $Root/Margin/Column/RefuseRow/RefuseLabel


func _ready() -> void:
	_prompt.text = OldManHelpChoice.PROMPT
	_accept.text = OldManHelpChoice.label_for(OldManHelpChoice.ACCEPT)
	_refuse.text = OldManHelpChoice.label_for(OldManHelpChoice.REFUSE)
	_paint()


func open() -> void:
	if _root.visible:
		return
	_index = 0
	_root.visible = true
	_paint()


func close() -> void:
	_root.visible = false


func highlight_previous() -> void:
	_index = maxi(_index - 1, 0)
	_paint()


func highlight_next() -> void:
	_index = mini(_index + 1, _OPTIONS.size() - 1)
	_paint()


func selected_option() -> String:
	return _OPTIONS[_index]


func _paint() -> void:
	var accept_on := _index == 0
	_accept_marker.text = ">" if accept_on else ""
	_refuse_marker.text = "" if accept_on else ">"
	_accept_marker.add_theme_color_override("font_color", LIT if accept_on else DIM)
	_refuse_marker.add_theme_color_override("font_color", DIM if accept_on else LIT)
	_accept.add_theme_color_override("font_color", LIT if accept_on else DIM)
	_refuse.add_theme_color_override("font_color", DIM if accept_on else LIT)
