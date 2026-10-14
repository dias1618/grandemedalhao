class_name CombatSession
extends RefCounted

## Runs the practice fight until victory, defeat, or flee.
## Start copies the player and builds practice_pirate, then sets combat.
## Submit takes the player's action. The enemy action and the round come from CombatRound.
## Rolls arrive from the caller, in execution order. This session does not pick a random number.
## A finished result is kept. A later submit does not execute again.
## PlayerState, mission, world flags, and the scene stay untouched.


var _player: Combatant = null
var _pirate: Combatant = null
var _result: String = CombatRound.OUTCOME_ONGOING


func start(state: GameState) -> void:
	if state == null or state.mode == null or state.player == null:
		return
	_player = PracticeFight.player_combatant(state.player)
	_pirate = PracticeFight.enemy()
	_result = CombatRound.OUTCOME_ONGOING
	state.mode.id = GameMode.COMBAT


func submit(action_type: String, rolls: Array) -> String:
	if _finished() or _player == null or _pirate == null:
		return _result
	var player_action := _player_action(action_type)
	if player_action == null:
		return _result
	var actions: Array = [player_action]
	var enemy_action := CombatRound.practice_enemy_action([_player, _pirate])
	if enemy_action != null:
		actions.append(enemy_action)
	_result = CombatRound.execute([_player, _pirate], actions, rolls)
	return _result


func result() -> String:
	return _result


func player_combatant() -> Combatant:
	return _player


func practice_pirate() -> Combatant:
	return _pirate


func _player_action(action_type: String) -> CombatRound.Action:
	if action_type == CombatRound.ATTACK:
		if _pirate == null or _pirate.is_defeated():
			return null
		return CombatRound.action(_player.id, CombatRound.ATTACK, _pirate.id)
	if action_type == CombatRound.DEFEND or action_type == CombatRound.FLEE:
		return CombatRound.action(_player.id, action_type)
	return null


func _finished() -> bool:
	return (
		_result == CombatRound.OUTCOME_VICTORY
		or _result == CombatRound.OUTCOME_DEFEAT
		or _result == CombatRound.OUTCOME_FLEE
	)
