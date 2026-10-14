extends RefCounted

const PlayerStateScript := preload("res://domain/state/player_state.gd")
const CombatantScript := preload("res://domain/combat/combatant.gd")
const PracticeFightScript := preload("res://domain/combat/practice_fight.gd")


func run() -> bool:
	if not _player_copy_matches_defaults_without_writing_back():
		return false
	if not _practice_enemy_matches_fixed_stats_and_zero_hp_is_defeated():
		return false
	return _hp_below_zero_is_rejected()


func _player_copy_matches_defaults_without_writing_back() -> bool:
	var player: RefCounted = PlayerStateScript.new()
	var combatant: RefCounted = CombatantScript.from_player(player)
	if combatant.get("id") != "zoro":
		return false
	if combatant.get("side") != "player":
		return false
	if combatant.get("hp") != 10:
		return false
	if combatant.get("max_hp") != 10:
		return false
	if combatant.get("energy") != 10:
		return false
	if combatant.get("strength") != 10:
		return false
	if combatant.get("defense") != 10:
		return false
	if combatant.get("speed") != 10:
		return false
	if combatant.get("luck") != 10:
		return false
	if player.get("hp") != 10:
		return false
	combatant.set("hp", 4)
	combatant.set("strength", 1)
	if player.get("hp") != 10 or player.get("strength") != 10:
		return false
	player.set("hp", 7)
	player.set("energy", 3)
	if combatant.get("hp") != 4 or combatant.get("energy") != 10:
		return false
	if player.get("hp") != 7:
		return false
	var custom: RefCounted = CombatantScript.from_player(player)
	if custom.get("hp") != 7 or custom.get("max_hp") != 7:
		return false
	if custom.get("energy") != 3 or custom.get("id") != "zoro":
		return false
	if player.get("hp") != 7:
		return false
	var built: Array = PracticeFightScript.sides(player)
	if built.size() != 2:
		return false
	if built[0].get("side") != "player" or built[0].get("hp") != 7:
		return false
	if PracticeFightScript.ID != "practice_fight":
		return false
	return built[1].get("id") == "practice_pirate"


func _practice_enemy_matches_fixed_stats_and_zero_hp_is_defeated() -> bool:
	var pirate: RefCounted = PracticeFightScript.enemy()
	if pirate.get("id") != "practice_pirate":
		return false
	if pirate.get("side") != "enemy":
		return false
	if pirate.get("hp") != 16 or pirate.get("max_hp") != 16:
		return false
	if pirate.get("energy") != 10:
		return false
	if pirate.get("strength") != 12:
		return false
	if pirate.get("defense") != 6:
		return false
	if pirate.get("speed") != 8:
		return false
	if pirate.get("luck") != 5:
		return false
	if pirate.call("is_defeated"):
		return false
	pirate.set("hp", 1)
	if pirate.call("is_defeated"):
		return false
	pirate.set("hp", 0)
	if not pirate.call("is_defeated"):
		return false
	pirate.set("side", "player")
	return pirate.get("side") == "player"


func _hp_below_zero_is_rejected() -> bool:
	var pirate: RefCounted = PracticeFightScript.enemy()
	pirate.set("hp", -1)
	if pirate.get("hp") != 16 or pirate.call("is_defeated"):
		return false
	pirate.set("hp", 0)
	pirate.set("hp", -4)
	if pirate.get("hp") != 0 or not pirate.call("is_defeated"):
		return false
	var player: RefCounted = PlayerStateScript.new()
	var combatant: RefCounted = CombatantScript.from_player(player)
	combatant.set("hp", -1)
	if combatant.get("hp") != 10:
		return false
	combatant.set("side", "neutral")
	if combatant.get("side") != "player":
		return false
	return player.get("hp") == 10
