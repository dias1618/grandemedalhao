extends RefCounted

const CombatSessionScript := preload("res://application/combat/combat_session.gd")
const CombatRoundScript := preload("res://domain/combat/combat_round.gd")
const GameStateScript := preload("res://domain/state/game_state.gd")
const GameModeScript := preload("res://domain/state/game_mode.gd")


func run() -> bool:
	if not _four_hits_reach_victory_and_keep_player_hp():
		return false
	if not _first_action_flee_leaves_the_pirate_alive():
		return false
	return _action_after_victory_keeps_the_result()


func _four_hits_reach_victory_and_keep_player_hp() -> bool:
	var state := _session()
	var session := _session_fight(state)
	if state.get("mode").get("id") != GameModeScript.COMBAT:
		return false
	if state.get("player").get("hp") != 10:
		return false
	if session.call("practice_pirate").get("hp") != 16:
		return false
	if session.call("player_combatant").get("hp") != 10:
		return false
	for _index in range(3):
		var ongoing: String = session.call("submit", CombatRoundScript.ATTACK, [0, 0])
		if ongoing != CombatRoundScript.OUTCOME_ONGOING:
			return false
		if state.get("mode").get("id") != GameModeScript.COMBAT:
			return false
	if session.call("practice_pirate").get("hp") != 4:
		return false
	if session.call("player_combatant").get("hp") != 4:
		return false
	var outcome: String = session.call("submit", CombatRoundScript.ATTACK, [0, 0])
	if outcome != CombatRoundScript.OUTCOME_VICTORY:
		return false
	if session.call("result") != CombatRoundScript.OUTCOME_VICTORY:
		return false
	if session.call("practice_pirate").get("hp") != 0:
		return false
	if session.call("player_combatant").get("hp") != 4:
		return false
	if state.get("player").get("hp") != 10:
		return false
	if state.get("mode").get("id") != GameModeScript.COMBAT:
		return false
	return _narrative_unchanged(state)


func _first_action_flee_leaves_the_pirate_alive() -> bool:
	var state := _session()
	var session := _session_fight(state)
	var defended: String = session.call("submit", CombatRoundScript.DEFEND, [0])
	if defended != CombatRoundScript.OUTCOME_ONGOING:
		return false
	if session.call("player_combatant").get("hp") != 9:
		return false
	if session.call("practice_pirate").get("hp") != 16:
		return false
	if state.get("player").get("hp") != 10:
		return false

	var fled_state := _session()
	var fled := _session_fight(fled_state)
	var outcome: String = fled.call("submit", CombatRoundScript.FLEE, [0, 0])
	if outcome != CombatRoundScript.OUTCOME_FLEE:
		return false
	if fled.call("result") != CombatRoundScript.OUTCOME_FLEE:
		return false
	if fled.call("practice_pirate").get("hp") != 16 or fled.call("practice_pirate").call("is_defeated"):
		return false
	if fled.call("player_combatant").get("hp") != 10:
		return false
	if fled_state.get("player").get("hp") != 10:
		return false
	if fled_state.get("mode").get("id") != GameModeScript.COMBAT:
		return false
	var again: String = fled.call("submit", CombatRoundScript.ATTACK, [0, 0])
	if again != CombatRoundScript.OUTCOME_FLEE:
		return false
	if fled.call("practice_pirate").get("hp") != 16:
		return false
	if fled.call("player_combatant").get("hp") != 10:
		return false
	if fled_state.get("player").get("hp") != 10:
		return false
	return _narrative_unchanged(state) and _narrative_unchanged(fled_state)


func _action_after_victory_keeps_the_result() -> bool:
	var state := _session()
	var session := _session_fight(state)
	for _index in range(4):
		session.call("submit", CombatRoundScript.ATTACK, [0, 0])
	if session.call("result") != CombatRoundScript.OUTCOME_VICTORY:
		return false
	var pirate_hp: int = session.call("practice_pirate").get("hp")
	var copy_hp: int = session.call("player_combatant").get("hp")
	var again: String = session.call("submit", CombatRoundScript.ATTACK, [0, 0])
	if again != CombatRoundScript.OUTCOME_VICTORY:
		return false
	if session.call("result") != CombatRoundScript.OUTCOME_VICTORY:
		return false
	if session.call("practice_pirate").get("hp") != pirate_hp:
		return false
	if session.call("player_combatant").get("hp") != copy_hp:
		return false
	if state.get("player").get("hp") != 10:
		return false
	if state.get("mode").get("id") != GameModeScript.COMBAT:
		return false
	if state.get("current_scene_id") != "bar":
		return false
	return _narrative_unchanged(state)


func _session_fight(state: RefCounted) -> RefCounted:
	var session: RefCounted = CombatSessionScript.new()
	session.call("start", state)
	return session


func _session() -> RefCounted:
	var state: RefCounted = GameStateScript.new()
	state.get("mode").set("id", GameModeScript.EXPLORATION)
	state.get("world").call("set_flag", &"kept_flag", true)
	state.set("mission", "kept_mission")
	state.set("current_scene_id", "bar")
	return state


func _narrative_unchanged(state: RefCounted) -> bool:
	if state.get("mission") != "kept_mission":
		return false
	if state.get("current_scene_id") != "bar":
		return false
	var flags: Dictionary = state.get("world").call("flags")
	return flags.size() == 1 and flags.get("kept_flag") == true
