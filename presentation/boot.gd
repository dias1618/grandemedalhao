extends Node

## Session entry. A new session enters the bar and shows the bar placeholder.
## The visible session starts in exploration by direct assignment. There is no mode-transition table.
## Interact that returns old_man_conversation starts the dialogue controller.
## Confirm during dialogue completes the current line or advances through the reveal rule.
## When the five lines finish, choice opens if the mission is not started.
## That assignment happens after advance and before the next movement frame.
## While the mode is choice, up and down move the highlight and confirm applies it.
## The reply lines then show in the dialogue box and the choice box hides.
## Reply lines still finish in exploration.
## During exploration, back starts the practice fight. Dialogue and choice ignore back.
## While the mode is combat, up and down move the highlight and confirm submits it.
## Victory, defeat, and flee assign exploration on that same confirm and hide the box.
## Headless runs quit in _ready so import and CI do not hang.

const EnterSceneScript := preload("res://application/enter_scene.gd")
const GameStateScript := preload("res://domain/state/game_state.gd")
const GameModeScript := preload("res://domain/state/game_mode.gd")
const MovePlayerScript := preload("res://application/movement/move_player.gd")
const TryInteractScript := preload("res://application/interaction/try_interact.gd")
const DialogueControllerScript := preload("res://application/dialogue/dialogue_controller.gd")
const ResolveOldManChoiceScript := preload("res://application/choice/resolve_old_man_choice.gd")
const LineRevealScript := preload("res://application/dialogue/line_reveal.gd")
const InputActionScript := preload("res://application/input/input_action.gd")
const KeyboardInputMapperScript := preload("res://presentation/input/keyboard_input_mapper.gd")
const PlaceholderScene := preload("res://presentation/scenes/exploration_placeholder.tscn")
const BarScene := preload("res://presentation/scenes/bar_placeholder.tscn")
const DialogueBoxScene := preload("res://presentation/dialogue/dialogue_box.tscn")
const ChoiceBoxScene := preload("res://presentation/choice/choice_box.tscn")
const CombatBoxScene := preload("res://presentation/combat/combat_box.tscn")

var session: RefCounted
var interact_result: String = ""
var _dialogue: RefCounted = DialogueControllerScript.new()
var _reveal: RefCounted = LineRevealScript.new()
var _fight: CombatSession
var _offer_choice_when_conversation_ends := false
var _box: CanvasLayer
var _choice: CanvasLayer
var _combat: CanvasLayer
var _blocker: Dictionary = {}


func _ready() -> void:
	session = GameStateScript.new()
	_fight = CombatSession.new()
	session.get("mode").set("id", GameModeScript.EXPLORATION)
	EnterSceneScript.enter(session, "bar")
	_box = DialogueBoxScene.instantiate()
	add_child(_box)
	_choice = ChoiceBoxScene.instantiate()
	add_child(_choice)
	_combat = CombatBoxScene.instantiate()
	add_child(_combat)
	_place_view_for_active_scene()
	if DisplayServer.get_name() == "headless":
		get_tree().quit()


func _process(delta: float) -> void:
	if session == null:
		return
	var frame: RefCounted = KeyboardInputMapperScript.read()
	var mode_id: StringName = session.get("mode").get("id")
	if mode_id == GameModeScript.EXPLORATION:
		MovePlayerScript.step(session.get("player"), session.get("mode"), frame, delta, _blocker)
		if frame.is_just_pressed(InputActionScript.BACK):
			_fight.start(session as GameState)
			if session.get("mode").get("id") == GameModeScript.COMBAT:
				_combat.call("open", _fight)
	if frame.is_just_pressed(InputActionScript.INTERACT):
		interact_result = TryInteractScript.execute(session, frame)
		if interact_result == "old_man_conversation":
			_dialogue.call("start", session, interact_result)
			_offer_choice_when_conversation_ends = _dialogue.call("current_line") != null
	_box.call("follow", _dialogue, _reveal)
	if mode_id == GameModeScript.DIALOGUE and frame.is_just_pressed(InputActionScript.CONFIRM):
		var decision: StringName = _reveal.call("confirm")
		if decision == LineRevealScript.COMPLETE:
			_box.call("show_full_line")
		elif decision == LineRevealScript.ADVANCE:
			var had_line: bool = _dialogue.call("current_line") != null
			_dialogue.call("advance", session)
			if (
				_offer_choice_when_conversation_ends
				and had_line
				and _dialogue.call("current_line") == null
			):
				_offer_choice_when_conversation_ends = false
				ResolveOldManChoiceScript.offer(session)
			_box.call("follow", _dialogue, _reveal)
	if mode_id == GameModeScript.CHOICE:
		_choice.call("open")
		if frame.is_just_pressed(InputActionScript.MOVE_UP):
			_choice.call("highlight_previous")
		if frame.is_just_pressed(InputActionScript.MOVE_DOWN):
			_choice.call("highlight_next")
		if frame.is_just_pressed(InputActionScript.CONFIRM):
			var option_id: String = _choice.call("selected_option")
			ResolveOldManChoiceScript.select(session, _dialogue, option_id)
			_box.call("follow", _dialogue, _reveal)
			_choice.call("close")
	if mode_id == GameModeScript.COMBAT:
		if frame.is_just_pressed(InputActionScript.MOVE_UP):
			_combat.call("highlight_previous")
		if frame.is_just_pressed(InputActionScript.MOVE_DOWN):
			_combat.call("highlight_next")
		if frame.is_just_pressed(InputActionScript.CONFIRM):
			var action: String = _combat.call("selected_action")
			var outcome: String = _fight.submit(action, [0, 0])
			_combat.call("refresh", _fight)
			if _fight_finished(outcome):
				session.get("mode").set("id", GameModeScript.EXPLORATION)
				_combat.call("close")
	_show_marker_at_player()


func _fight_finished(outcome: String) -> bool:
	return (
		outcome == CombatRound.OUTCOME_VICTORY
		or outcome == CombatRound.OUTCOME_DEFEAT
		or outcome == CombatRound.OUTCOME_FLEE
	)


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
	if scene_id == "bar":
		return BarScene
	if scene_id == "outside" or scene_id == "pirate_cave":
		return PlaceholderScene
	return null
