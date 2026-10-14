class_name InteractionTarget
extends RefCounted

## A fixed interactable: id, position, inclusive range in pixels, and conversation id.
## The only target is old_man. The bar placeholder draws OldManMarker at the same position.
## This type does not read Input or load a scene.


const OLD_MAN_POSITION := Vector2(160, 80)
const OLD_MAN_RANGE := 64.0

var id: String = ""
var position: Vector2 = Vector2.ZERO
var range: float = 0.0
var conversation_id: String = ""


static func old_man() -> InteractionTarget:
	var target := InteractionTarget.new()
	target.id = "old_man"
	target.position = OLD_MAN_POSITION
	target.range = OLD_MAN_RANGE
	target.conversation_id = "old_man_conversation"
	return target


func contains(point: Vector2) -> bool:
	return position.distance_to(point) <= range
