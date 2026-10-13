class_name PlayerState
extends RefCounted

## Persistent protagonist data. character_id names who is playing; it is not a character class.
## scene_id starts empty. This object does not choose an opening scene.

const FACINGS: Array[String] = ["up", "down", "left", "right"]

var character_id: String = "zoro":
	set(value):
		if value.is_empty():
			return
		character_id = value

var position: Vector2 = Vector2.ZERO
var scene_id: String = ""

## Facing. Only up, down, left, or right. Default is down.
var direction: String = "down":
	set(value):
		if value not in FACINGS:
			return
		direction = value

## Positive defaults for a later combat prototype. Not a tuned character sheet.
var hp: int = 10
var energy: int = 10
var strength: int = 10
var defense: int = 10
var speed: int = 10
var luck: int = 10
