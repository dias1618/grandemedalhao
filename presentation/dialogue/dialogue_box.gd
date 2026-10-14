extends CanvasLayer

## Bottom dialogue box. Reads the current line from DialogueController.
## Portrait stand-ins are colored blocks. Narration hides the portrait.
## Thought uses a different panel from normal speech.
## Progressive reveal speed lives here. Confirm is decided by LineReveal.


const CHARACTERS_PER_SECOND := 42.0

const NORMAL_PANEL := Color(0.09, 0.06, 0.05, 0.94)
const THOUGHT_PANEL := Color(0.16, 0.15, 0.32, 0.94)
const NARRATION_PANEL := Color(0.07, 0.07, 0.08, 0.92)

const NORMAL_SPEAKER := Color(0.95, 0.86, 0.62, 1)
const THOUGHT_SPEAKER := Color(0.78, 0.8, 1, 1)
const NORMAL_TEXT := Color(0.95, 0.93, 0.88, 1)
const THOUGHT_TEXT := Color(0.86, 0.88, 0.98, 1)

const PORTRAIT_COLORS := {
	"old_man": Color(0.78, 0.72, 0.58, 1),
	"zoro": Color(0.16, 0.42, 0.28, 1),
}

var _controller: RefCounted
var _reveal: RefCounted
var _line: DialogueLine
var _shown := 0.0

@onready var _root: Control = $Root
@onready var _background: ColorRect = $Root/Background
@onready var _portrait: ColorRect = $Root/Margin/Row/Portrait
@onready var _speaker: Label = $Root/Margin/Row/Column/Speaker
@onready var _text: Label = $Root/Margin/Row/Column/Text


func follow(controller: RefCounted, reveal: RefCounted) -> void:
	_controller = controller
	_reveal = reveal
	var line: DialogueLine = controller.call("current_line")
	if line == _line:
		return
	_line = line
	_shown = 0.0
	reveal.call("begin", line)
	if line == null:
		_root.visible = false
		_speaker.text = ""
		_text.text = ""
		return
	_root.visible = true
	_speaker.text = line.speaker
	_text.text = ""
	_apply_style(line)


func show_full_line() -> void:
	if _line == null:
		return
	_shown = float(_line.text.length())
	_text.text = _line.text


func _process(delta: float) -> void:
	if _line == null or _reveal == null:
		return
	var full := _line.text
	var total := full.length()
	if _shown >= float(total):
		_text.text = full
		_reveal.call("finish_reveal")
		return
	_shown = minf(_shown + delta * CHARACTERS_PER_SECOND, float(total))
	var count := int(_shown)
	_text.text = full.substr(0, count)
	if count >= total:
		_reveal.call("finish_reveal")


func _apply_style(line: DialogueLine) -> void:
	var thought := line.type == DialogueLine.THOUGHT
	var narration := line.type == DialogueLine.NARRATION
	if thought:
		_background.color = THOUGHT_PANEL
		_speaker.add_theme_color_override("font_color", THOUGHT_SPEAKER)
		_text.add_theme_color_override("font_color", THOUGHT_TEXT)
	elif narration:
		_background.color = NARRATION_PANEL
		_speaker.add_theme_color_override("font_color", NORMAL_SPEAKER)
		_text.add_theme_color_override("font_color", NORMAL_TEXT)
	else:
		_background.color = NORMAL_PANEL
		_speaker.add_theme_color_override("font_color", NORMAL_SPEAKER)
		_text.add_theme_color_override("font_color", NORMAL_TEXT)
	_apply_portrait(line, narration)


func _apply_portrait(line: DialogueLine, narration: bool) -> void:
	if narration or line.portrait.is_empty():
		_portrait.visible = false
		return
	_portrait.visible = true
	_portrait.color = PORTRAIT_COLORS.get(line.portrait, Color(0.4, 0.4, 0.4, 1))
