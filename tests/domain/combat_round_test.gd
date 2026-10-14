extends RefCounted

const PlayerStateScript := preload("res://domain/state/player_state.gd")
const CombatantScript := preload("res://domain/combat/combatant.gd")
const PracticeFightScript := preload("res://domain/combat/practice_fight.gd")
const CombatRoundScript := preload("res://domain/combat/combat_round.gd")


func run() -> bool:
	if not _both_attacks_roll_zero_and_faster_side_hits_first():
		return false
	if not _roll_99_misses_defend_halves_and_flee_zero():
		return false
	if not _roll_100_rejects_that_action():
		return false
	if not _order_uses_hp_then_side_then_id_without_resorting():
		return false
	return _practice_enemy_attacks_the_first_living_player()


func _both_attacks_roll_zero_and_faster_side_hits_first() -> bool:
	var sides: Array = _practice_sides()
	var player: Object = sides[0]
	var pirate: Object = sides[1]
	var player_hp: int = player.get("hp")
	var pirate_hp: int = pirate.get("hp")
	var player_action: Object = CombatRoundScript.action(
		player.get("id"),
		CombatRoundScript.ATTACK,
		pirate.get("id")
	)
	var enemy_action: Object = CombatRoundScript.practice_enemy_action(sides)
	if player.get("hp") != player_hp or pirate.get("hp") != pirate_hp:
		return false
	if enemy_action == null or enemy_action.get("type") != CombatRoundScript.ATTACK:
		return false
	if enemy_action.get("actor_id") != PracticeFightScript.ENEMY_ID:
		return false
	if enemy_action.get("target_id") != player.get("id"):
		return false
	if player_action.get("target_id") != PracticeFightScript.ENEMY_ID:
		return false
	var outcome: String = CombatRoundScript.execute(sides, [player_action, enemy_action], [0, 0])
	if outcome != CombatRoundScript.OUTCOME_ONGOING:
		return false
	if pirate.get("hp") != 12 or player.get("hp") != 8:
		return false
	if player.get("energy") != 10 or pirate.get("energy") != 10:
		return false

	var lethal: Array = _practice_sides()
	lethal[1].set("hp", 4)
	var lethal_player: Object = CombatRoundScript.action(
		lethal[0].get("id"),
		CombatRoundScript.ATTACK,
		lethal[1].get("id")
	)
	var lethal_enemy: Object = CombatRoundScript.practice_enemy_action(lethal)
	var lethal_outcome: String = CombatRoundScript.execute(
		lethal,
		[lethal_enemy, lethal_player],
		[0, 0]
	)
	if lethal_outcome != CombatRoundScript.OUTCOME_VICTORY:
		return false
	if lethal[0].get("hp") != 10 or lethal[1].get("hp") != 0:
		return false
	return lethal[1].call("is_defeated")


func _roll_99_misses_defend_halves_and_flee_zero() -> bool:
	var missed: Array = _practice_sides()
	var miss_outcome: String = CombatRoundScript.execute(
		missed,
		[
			CombatRoundScript.action(missed[0].get("id"), CombatRoundScript.ATTACK, missed[1].get("id")),
			CombatRoundScript.action(missed[1].get("id"), CombatRoundScript.ATTACK, missed[0].get("id")),
		],
		[99, 99]
	)
	if miss_outcome != CombatRoundScript.OUTCOME_ONGOING:
		return false
	if missed[0].get("hp") != 10 or missed[1].get("hp") != 16:
		return false

	var guarded: Array = _practice_sides()
	var guarded_outcome: String = CombatRoundScript.execute(
		guarded,
		[
			CombatRoundScript.action(guarded[0].get("id"), CombatRoundScript.ATTACK, guarded[1].get("id")),
			CombatRoundScript.action(guarded[1].get("id"), CombatRoundScript.DEFEND),
		],
		[0]
	)
	if guarded_outcome != CombatRoundScript.OUTCOME_ONGOING:
		return false
	if guarded[1].get("hp") != 14 or guarded[0].get("hp") != 10:
		return false
	if CombatRoundScript.action(guarded[1].get("id"), CombatRoundScript.DEFEND).get("target_id") != "":
		return false
	var open_outcome: String = CombatRoundScript.execute(
		guarded,
		[
			CombatRoundScript.action(guarded[0].get("id"), CombatRoundScript.ATTACK, guarded[1].get("id")),
			CombatRoundScript.action(guarded[1].get("id"), CombatRoundScript.ATTACK, guarded[0].get("id")),
		],
		[0, 0]
	)
	if open_outcome != CombatRoundScript.OUTCOME_ONGOING:
		return false
	if guarded[1].get("hp") != 10 or guarded[0].get("hp") != 8:
		return false

	var player_guard: Array = _practice_sides()
	CombatRoundScript.execute(
		player_guard,
		[
			CombatRoundScript.action(player_guard[0].get("id"), CombatRoundScript.DEFEND),
			CombatRoundScript.action(player_guard[1].get("id"), CombatRoundScript.ATTACK, player_guard[0].get("id")),
		],
		[0]
	)
	if player_guard[0].get("hp") != 9 or player_guard[1].get("hp") != 16:
		return false

	var odd: Array = _practice_sides()
	odd[0].set("strength", 11)
	CombatRoundScript.execute(
		odd,
		[
			CombatRoundScript.action(odd[0].get("id"), CombatRoundScript.ATTACK, odd[1].get("id")),
			CombatRoundScript.action(odd[1].get("id"), CombatRoundScript.DEFEND),
		],
		[0]
	)
	if odd[1].get("hp") != 14:
		return false

	var fled: Array = _practice_sides()
	var flee_action: Object = CombatRoundScript.action(fled[0].get("id"), CombatRoundScript.FLEE)
	if flee_action.get("target_id") != "":
		return false
	var flee_outcome: String = CombatRoundScript.execute(
		fled,
		[
			flee_action,
			CombatRoundScript.action(fled[1].get("id"), CombatRoundScript.ATTACK, fled[0].get("id")),
		],
		[0, 0]
	)
	if flee_outcome != CombatRoundScript.OUTCOME_FLEE:
		return false
	if fled[0].get("hp") != 10 or fled[1].get("hp") != 16 or fled[1].call("is_defeated"):
		return false

	var failed: Array = _practice_sides()
	var failed_outcome: String = CombatRoundScript.execute(
		failed,
		[
			CombatRoundScript.action(failed[0].get("id"), CombatRoundScript.FLEE),
			CombatRoundScript.action(failed[1].get("id"), CombatRoundScript.ATTACK, failed[0].get("id")),
		],
		[99, 0]
	)
	if failed_outcome != CombatRoundScript.OUTCOME_ONGOING:
		return false
	if failed[0].get("hp") != 8 or failed[1].get("hp") != 16:
		return false

	if not _chance_stays_inside_bounds():
		return false
	return _flee_uses_fastest_living_opponent()


func _roll_100_rejects_that_action() -> bool:
	var only_invalid: Array = _practice_sides()
	var only_outcome: String = CombatRoundScript.execute(
		only_invalid,
		[CombatRoundScript.action(only_invalid[0].get("id"), CombatRoundScript.ATTACK, only_invalid[1].get("id"))],
		[100]
	)
	if only_outcome != CombatRoundScript.OUTCOME_ONGOING:
		return false
	if only_invalid[0].get("hp") != 10 or only_invalid[1].get("hp") != 16:
		return false

	var mixed: Array = _practice_sides()
	var mixed_outcome: String = CombatRoundScript.execute(
		mixed,
		[
			CombatRoundScript.action(mixed[0].get("id"), CombatRoundScript.ATTACK, mixed[1].get("id")),
			CombatRoundScript.action(mixed[1].get("id"), CombatRoundScript.ATTACK, mixed[0].get("id")),
		],
		[100, 0]
	)
	if mixed_outcome != CombatRoundScript.OUTCOME_ONGOING:
		return false
	if mixed[1].get("hp") != 16 or mixed[0].get("hp") != 8:
		return false

	var later_invalid: Array = _practice_sides()
	CombatRoundScript.execute(
		later_invalid,
		[
			CombatRoundScript.action(later_invalid[0].get("id"), CombatRoundScript.ATTACK, later_invalid[1].get("id")),
			CombatRoundScript.action(later_invalid[1].get("id"), CombatRoundScript.ATTACK, later_invalid[0].get("id")),
		],
		[0, 100]
	)
	if later_invalid[1].get("hp") != 12 or later_invalid[0].get("hp") != 10:
		return false

	var negative: Array = _practice_sides()
	CombatRoundScript.execute(
		negative,
		[
			CombatRoundScript.action(negative[0].get("id"), CombatRoundScript.ATTACK, negative[1].get("id")),
			CombatRoundScript.action(negative[1].get("id"), CombatRoundScript.ATTACK, negative[0].get("id")),
		],
		[-1, 0]
	)
	if negative[1].get("hp") != 16 or negative[0].get("hp") != 8:
		return false

	var fractional: Array = _practice_sides()
	CombatRoundScript.execute(
		fractional,
		[CombatRoundScript.action(fractional[0].get("id"), CombatRoundScript.ATTACK, fractional[1].get("id"))],
		[0.0]
	)
	if fractional[0].get("hp") != 10 or fractional[1].get("hp") != 16:
		return false

	var bruised: Array = [
		_combatant("zoro", "player", 3, 1, 0, 1, 0),
		_combatant("practice_pirate", "enemy", 3, 100, 0, 1, 50),
	]
	var bruise_outcome: String = CombatRoundScript.execute(
		bruised,
		[CombatRoundScript.action("practice_pirate", CombatRoundScript.ATTACK, "zoro")],
		[0]
	)
	if bruise_outcome != CombatRoundScript.OUTCOME_DEFEAT:
		return false
	if bruised[0].get("hp") != 0 or bruised[1].get("hp") != 3:
		return false
	bruised[0].set("hp", 3)
	bruised[1].set("strength", 1)
	bruised[0].set("strength", 100)
	var floor_outcome: String = CombatRoundScript.execute(
		bruised,
		[CombatRoundScript.action("zoro", CombatRoundScript.ATTACK, "practice_pirate")],
		[0]
	)
	if floor_outcome != CombatRoundScript.OUTCOME_VICTORY:
		return false
	return bruised[1].get("hp") == 0 and bruised[0].get("hp") == 3


func _order_uses_hp_then_side_then_id_without_resorting() -> bool:
	var higher_hp: Array = [
		_combatant("zoro", "player", 5, 10, 0, 5, 50),
		_combatant("practice_pirate", "enemy", 9, 10, 0, 5, 50),
	]
	var higher_hp_outcome: String = CombatRoundScript.execute(
		higher_hp,
		[
			CombatRoundScript.action("zoro", CombatRoundScript.ATTACK, "practice_pirate"),
			CombatRoundScript.action("practice_pirate", CombatRoundScript.ATTACK, "zoro"),
		],
		[0, 0]
	)
	if higher_hp_outcome != CombatRoundScript.OUTCOME_DEFEAT:
		return false
	if higher_hp[0].get("hp") != 0 or higher_hp[1].get("hp") != 9:
		return false

	var same_hp: Array = [
		_combatant("zoro", "player", 10, 10, 0, 5, 50),
		_combatant("practice_pirate", "enemy", 10, 10, 0, 5, 50),
	]
	var same_hp_outcome: String = CombatRoundScript.execute(
		same_hp,
		[
			CombatRoundScript.action("practice_pirate", CombatRoundScript.ATTACK, "zoro"),
			CombatRoundScript.action("zoro", CombatRoundScript.ATTACK, "practice_pirate"),
		],
		[0, 0]
	)
	if same_hp_outcome != CombatRoundScript.OUTCOME_VICTORY:
		return false
	if same_hp[0].get("hp") != 10 or same_hp[1].get("hp") != 0:
		return false

	var by_id: Array = [
		_combatant("b", "player", 10, 10, 0, 5, 50),
		_combatant("a", "player", 10, 10, 0, 5, 50),
		_combatant("practice_pirate", "enemy", 16, 1, 6, 1, 0),
	]
	var by_id_outcome: String = CombatRoundScript.execute(
		by_id,
		[
			CombatRoundScript.action("b", CombatRoundScript.FLEE),
			CombatRoundScript.action("a", CombatRoundScript.ATTACK, "practice_pirate"),
		],
		[0, 0]
	)
	if by_id_outcome != CombatRoundScript.OUTCOME_FLEE:
		return false
	if by_id[2].get("hp") != 12:
		return false

	var first: Object = _combatant("p1", "player", 10, 2, 100, 5, 50)
	var enemy: Object = _combatant("practice_pirate", "enemy", 9, 20, 0, 5, 50)
	var second: Object = _combatant("p2", "player", 8, 20, 0, 5, 50)
	var stable: Array = [second, enemy, first]
	var stable_outcome: String = CombatRoundScript.execute(
		stable,
		[
			CombatRoundScript.action("p2", CombatRoundScript.ATTACK, "practice_pirate"),
			CombatRoundScript.action("practice_pirate", CombatRoundScript.ATTACK, "p2"),
			CombatRoundScript.action("p1", CombatRoundScript.ATTACK, "practice_pirate"),
		],
		[0, 0, 0]
	)
	if stable_outcome != CombatRoundScript.OUTCOME_ONGOING:
		return false
	if first.get("hp") != 10 or enemy.get("hp") != 7 or second.get("hp") != 0:
		return false
	return second.call("is_defeated") and not enemy.call("is_defeated")


func _practice_enemy_attacks_the_first_living_player() -> bool:
	var sides: Array = _practice_sides()
	var before_player: int = sides[0].get("hp")
	var before_pirate: int = sides[1].get("hp")
	var chosen: Object = CombatRoundScript.practice_enemy_action(sides)
	if sides[0].get("hp") != before_player or sides[1].get("hp") != before_pirate:
		return false
	if chosen.get("type") != CombatRoundScript.ATTACK:
		return false
	if chosen.get("target_id") != "zoro":
		return false

	var fallen: Object = _combatant("zoro", "player", 0, 10, 10, 10, 10)
	var other: Object = _combatant("nami", "player", 9, 10, 10, 10, 10)
	var pirate: Object = PracticeFightScript.enemy()
	var next_target: Object = CombatRoundScript.practice_enemy_action([fallen, pirate, other])
	if next_target == null or next_target.get("type") != CombatRoundScript.ATTACK:
		return false
	if next_target.get("actor_id") != PracticeFightScript.ENEMY_ID:
		return false
	if next_target.get("target_id") != "nami":
		return false
	if fallen.get("hp") != 0 or other.get("hp") != 9 or pirate.get("hp") != 16:
		return false

	pirate.set("hp", 0)
	if CombatRoundScript.practice_enemy_action([fallen, other, pirate]) != null:
		return false
	if CombatRoundScript.action("zoro", "wait") != null:
		return false
	return pirate.get("hp") == 0 and other.get("hp") == 9


func _chance_stays_inside_bounds() -> bool:
	var low: Array = [
		_combatant("zoro", "player", 10, 1, 0, 1, 0),
		_combatant("practice_pirate", "enemy", 10, 1, 0, 80, 0),
	]
	CombatRoundScript.execute(
		low,
		[CombatRoundScript.action("zoro", CombatRoundScript.ATTACK, "practice_pirate")],
		[4]
	)
	if low[1].get("hp") != 9:
		return false
	low[1].set("hp", 10)
	CombatRoundScript.execute(
		low,
		[CombatRoundScript.action("zoro", CombatRoundScript.ATTACK, "practice_pirate")],
		[5]
	)
	if low[1].get("hp") != 10:
		return false

	var high: Array = [
		_combatant("zoro", "player", 10, 1, 0, 1, 80),
		_combatant("practice_pirate", "enemy", 10, 1, 0, 0, 0),
	]
	CombatRoundScript.execute(
		high,
		[CombatRoundScript.action("zoro", CombatRoundScript.ATTACK, "practice_pirate")],
		[94]
	)
	if high[1].get("hp") != 9:
		return false
	high[1].set("hp", 10)
	CombatRoundScript.execute(
		high,
		[CombatRoundScript.action("zoro", CombatRoundScript.ATTACK, "practice_pirate")],
		[95]
	)
	return high[1].get("hp") == 10


func _flee_uses_fastest_living_opponent() -> bool:
	var crowded: Array = [
		_combatant("zoro", "player", 10, 1, 0, 10, 0),
		_combatant("fast", "enemy", 0, 1, 0, 100, 0),
		_combatant("slow", "enemy", 10, 1, 0, 8, 0),
	]
	var succeeded: String = CombatRoundScript.execute(
		crowded,
		[CombatRoundScript.action("zoro", CombatRoundScript.FLEE)],
		[40]
	)
	if succeeded != CombatRoundScript.OUTCOME_FLEE:
		return false
	if crowded[2].get("hp") != 10:
		return false

	var clamped: Array = [
		_combatant("zoro", "player", 10, 1, 0, 1, 0),
		_combatant("practice_pirate", "enemy", 10, 1, 0, 100, 0),
	]
	var too_high: String = CombatRoundScript.execute(
		clamped,
		[CombatRoundScript.action("zoro", CombatRoundScript.FLEE)],
		[5]
	)
	if too_high != CombatRoundScript.OUTCOME_ONGOING:
		return false
	var barely: String = CombatRoundScript.execute(
		clamped,
		[CombatRoundScript.action("zoro", CombatRoundScript.FLEE)],
		[4]
	)
	return barely == CombatRoundScript.OUTCOME_FLEE


func _practice_sides() -> Array:
	return PracticeFightScript.sides(PlayerStateScript.new())


func _combatant(
	id: String,
	side: String,
	hp: int,
	strength: int,
	defense: int,
	speed: int,
	luck: int
) -> Object:
	var combatant: Object = CombatantScript.new()
	combatant.set("id", id)
	combatant.set("side", side)
	combatant.set("hp", hp)
	combatant.set("max_hp", hp)
	combatant.set("strength", strength)
	combatant.set("defense", defense)
	combatant.set("speed", speed)
	combatant.set("luck", luck)
	return combatant
