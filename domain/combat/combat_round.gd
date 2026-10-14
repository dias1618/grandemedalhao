class_name CombatRound
extends RefCounted

## One combat round from chosen actions and caller-supplied rolls.
## Choosing an action does not change hp. Execution is a separate step.


const ATTACK := "attack"
const DEFEND := "defend"
const FLEE := "flee"

const OUTCOME_VICTORY := "victory"
const OUTCOME_DEFEAT := "defeat"
const OUTCOME_FLEE := "flee"
const OUTCOME_ONGOING := "ongoing"

const _ACTIONS: Array[String] = [ATTACK, DEFEND, FLEE]
const _MIN_CHANCE := 5
const _MAX_CHANCE := 95


class Action:
	var actor_id: String = ""
	var type: String = ""
	var target_id: String = ""


static func action(actor_id: String, type: String, target_id: String = "") -> Action:
	if actor_id.is_empty() or type not in _ACTIONS:
		return null
	var chosen := Action.new()
	chosen.actor_id = actor_id
	chosen.type = type
	if type == ATTACK:
		chosen.target_id = target_id
	return chosen


static func practice_enemy_action(combatants: Array) -> Action:
	var pirate: Combatant = null
	for entry in combatants:
		var combatant := entry as Combatant
		if combatant == null:
			continue
		if combatant.id != PracticeFight.ENEMY_ID:
			continue
		if combatant.side != Combatant.SIDE_ENEMY or combatant.is_defeated():
			continue
		pirate = combatant
		break
	if pirate == null:
		return null
	for entry in combatants:
		var combatant := entry as Combatant
		if combatant == null:
			continue
		if combatant.side != Combatant.SIDE_PLAYER or combatant.is_defeated():
			continue
		return action(pirate.id, ATTACK, combatant.id)
	return null


static func execute(combatants: Array, actions: Array, rolls: Array) -> String:
	var opening := _outcome(combatants, false)
	if opening != OUTCOME_ONGOING:
		return opening

	var by_id := {}
	for entry in combatants:
		var combatant := entry as Combatant
		if combatant == null or combatant.id.is_empty():
			continue
		by_id[combatant.id] = combatant

	var defending := {}
	for entry in actions:
		var chosen := entry as Action
		if chosen != null and chosen.type == DEFEND:
			defending[chosen.actor_id] = true

	var roll_index := 0
	var fled := false
	for slot in _ordered_slots(actions, by_id):
		var chosen := slot["action"] as Action
		var actor: Combatant = by_id[chosen.actor_id]
		if chosen.type == DEFEND:
			continue
		if chosen.type != ATTACK and chosen.type != FLEE:
			continue
		var roll: Variant = _roll_at(rolls, roll_index)
		roll_index += 1
		if actor.is_defeated() or not _valid_roll(roll):
			continue
		if chosen.type == ATTACK:
			var target := by_id.get(chosen.target_id) as Combatant
			if target == null:
				continue
			_apply_attack(actor, target, int(roll), bool(defending.has(target.id)))
		elif _flee_succeeds(actor, combatants, int(roll)):
			fled = true
		var result := _outcome(combatants, fled)
		if result != OUTCOME_ONGOING:
			return result
	return _outcome(combatants, fled)


static func _ordered_slots(actions: Array, by_id: Dictionary) -> Array:
	var slots: Array = []
	for entry in actions:
		var chosen := entry as Action
		if chosen == null or not by_id.has(chosen.actor_id):
			continue
		var actor: Combatant = by_id[chosen.actor_id]
		slots.append({
			"action": chosen,
			"speed": actor.speed,
			"hp": actor.hp,
			"side": actor.side,
			"id": actor.id,
		})
	slots.sort_custom(_slot_before)
	return slots


static func _slot_before(a: Dictionary, b: Dictionary) -> bool:
	if int(a["speed"]) != int(b["speed"]):
		return int(a["speed"]) > int(b["speed"])
	if int(a["hp"]) != int(b["hp"]):
		return int(a["hp"]) > int(b["hp"])
	if str(a["side"]) != str(b["side"]):
		return str(a["side"]) == Combatant.SIDE_PLAYER
	return str(a["id"]) < str(b["id"])


static func _apply_attack(attacker: Combatant, target: Combatant, roll: int, target_defends: bool) -> void:
	var chance := clampi(50 + attacker.luck - target.speed, _MIN_CHANCE, _MAX_CHANCE)
	if roll >= chance:
		return
	var damage := maxi(0, attacker.strength - target.defense)
	if target_defends:
		damage = int(damage / 2.0)
	target.hp = maxi(0, target.hp - damage)


static func _flee_succeeds(actor: Combatant, combatants: Array, roll: int) -> bool:
	var chance := clampi(
		40 + actor.speed - _fastest_living_opponent_speed(actor, combatants),
		_MIN_CHANCE,
		_MAX_CHANCE
	)
	return roll < chance


static func _fastest_living_opponent_speed(actor: Combatant, combatants: Array) -> int:
	var fastest := 0
	var found := false
	for entry in combatants:
		var combatant := entry as Combatant
		if combatant == null or combatant.side == actor.side or combatant.is_defeated():
			continue
		if not found or combatant.speed > fastest:
			fastest = combatant.speed
			found = true
	return fastest


static func _outcome(combatants: Array, fled: bool) -> String:
	if _all_defeated(combatants, Combatant.SIDE_ENEMY):
		return OUTCOME_VICTORY
	if _all_defeated(combatants, Combatant.SIDE_PLAYER):
		return OUTCOME_DEFEAT
	if fled:
		return OUTCOME_FLEE
	return OUTCOME_ONGOING


static func _all_defeated(combatants: Array, side: String) -> bool:
	var found := false
	for entry in combatants:
		var combatant := entry as Combatant
		if combatant == null or combatant.side != side:
			continue
		found = true
		if not combatant.is_defeated():
			return false
	return found


static func _roll_at(rolls: Array, index: int) -> Variant:
	if index < 0 or index >= rolls.size():
		return null
	return rolls[index]


static func _valid_roll(roll: Variant) -> bool:
	return roll is int and roll >= 0 and roll <= 99
