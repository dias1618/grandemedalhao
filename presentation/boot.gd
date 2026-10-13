extends Node

## Session entry. A new session enters outside and shows the placeholder view.
## The visible session starts in exploration by direct assignment. There is no mode-transition table.
## Headless runs quit in _ready so import and CI do not hang.

const EnterSceneScript := preload("res://application/enter_scene.gd")
const GameStateScript := preload("res://domain/state/game_state.gd")
const GameModeScript := preload("res://domain/state/game_mode.gd")
const MovePlayerScript := preload("res://application/movement/move_player.gd")
const KeyboardInputMapperScript := preload("res://presentation/input/keyboard_input_mapper.gd")
const PlaceholderScene := preload("res://presentation/scenes/exploration_placeholder.tscn")

var session: RefCounted
var _blocker: Dictionary = {}


func _ready() -> void:
	session = GameStateScript.new()
	session.get("mode").set("id", GameModeScript.EXPLORATION)
	EnterSceneScript.enter(session, "outside")
	_place_view_for_active_scene()
	if DisplayServer.get_name() == "headless":
		get_tree().quit()


func _process(delta: float) -> void:
	if session == null:
		return
	if session.get("mode").get("id") != GameModeScript.EXPLORATION:
		_show_marker_at_player()
		return
	var frame: RefCounted = KeyboardInputMapperScript.read()
	MovePlayerScript.step(session.get("player"), session.get("mode"), frame, delta, _blocker)
	_show_marker_at_player()


func _place_view_for_active_scene() -> void:
	var scene_id: String = session.get("current_scene_id")
	var packed := _view_for(scene_id)
	if packed == null:
		return
	var view := packed.instantiate()
	view.name = "ActiveScene"
	add_child(view)
	_blocker = _rectangles_for(view)
	var camera := view.get_node_or_null("PlayerMarker/Camera2D") as Camera2D
	if camera == null:
		return
	camera.zoom = Vector2.ONE
	camera.make_current()
	_show_marker_at_player()


func _show_marker_at_player() -> void:
	var marker := get_node_or_null("ActiveScene/PlayerMarker") as Node2D
	if marker == null or session == null:
		return
	marker.position = session.get("player").get("position")


func _rectangles_for(view: Node) -> Dictionary:
	var half := _marker_half(view)
	var blocker := {"solids": []}
	var bounds_node := view.get_node_or_null("MapBounds") as Polygon2D
	if bounds_node != null:
		var visual := _polygon_rect(bounds_node)
		var playable := Rect2(visual.position + half, visual.size - half * 2.0)
		if playable.size.x > 0.0 and playable.size.y > 0.0:
			blocker["bounds"] = playable
	var solids: Array[Rect2] = []
	for node_name in ["Wall", "Prop"]:
		var solid := view.get_node_or_null(node_name) as Polygon2D
		if solid == null:
			continue
		solids.append(_polygon_rect(solid).grow_individual(half.x, half.y, half.x, half.y))
	blocker["solids"] = solids
	return blocker


func _polygon_rect(poly: Polygon2D) -> Rect2:
	var points := poly.polygon
	if points.is_empty():
		return Rect2()
	var min_point := poly.to_global(points[0])
	var max_point := min_point
	for point in points:
		var world := poly.to_global(point)
		min_point = min_point.min(world)
		max_point = max_point.max(world)
	return Rect2(min_point, max_point - min_point)


func _marker_half(view: Node) -> Vector2:
	var body := view.get_node_or_null("PlayerMarker/Body") as Polygon2D
	if body == null:
		return Vector2.ZERO
	return _polygon_rect(body).size * 0.5


func _view_for(scene_id: String) -> PackedScene:
	if scene_id == "outside" or scene_id == "bar" or scene_id == "pirate_cave":
		return PlaceholderScene
	return null
