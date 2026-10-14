class_name DialogueLine
extends RefCounted

## One dialogue line: speaker, text, type, optional portrait, and the next line.
## Types are normal, thought, and narration. Nothing here is drawn.


const NORMAL := "normal"
const THOUGHT := "thought"
const NARRATION := "narration"

const TYPES: Array[String] = [NORMAL, THOUGHT, NARRATION]

var speaker: String = "":
	set(value):
		if type == NORMAL and value.is_empty():
			return
		speaker = value

var text: String = ""
var portrait: String = ""
var next: DialogueLine = null

var type: String = "":
	set(value):
		if value not in TYPES:
			return
		if value == NORMAL and speaker.is_empty():
			return
		type = value


static func create(
	speaker: String,
	text: String,
	type: String,
	portrait: String = "",
	next_line: DialogueLine = null
) -> DialogueLine:
	if type not in TYPES:
		return null
	if type == NORMAL and speaker.is_empty():
		return null
	var line := DialogueLine.new()
	line.speaker = speaker
	line.text = text
	line.portrait = portrait
	line.type = type
	line.next = next_line
	return line
