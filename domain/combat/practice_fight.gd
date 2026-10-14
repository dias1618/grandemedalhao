class_name PracticeFight
extends RefCounted

## One fixed practice encounter. It does not open combat mode or touch the mission.


const ID := "practice_fight"
const ENEMY_ID := "practice_pirate"

const ENEMY_HP := 16
const ENEMY_ENERGY := 10
const ENEMY_STRENGTH := 12
const ENEMY_DEFENSE := 6
const ENEMY_SPEED := 8
const ENEMY_LUCK := 5


static func enemy() -> Combatant:
	var pirate := Combatant.new()
	pirate.id = ENEMY_ID
	pirate.side = Combatant.SIDE_ENEMY
	pirate.hp = ENEMY_HP
	pirate.max_hp = ENEMY_HP
	pirate.energy = ENEMY_ENERGY
	pirate.strength = ENEMY_STRENGTH
	pirate.defense = ENEMY_DEFENSE
	pirate.speed = ENEMY_SPEED
	pirate.luck = ENEMY_LUCK
	return pirate


static func player_combatant(player: PlayerState) -> Combatant:
	return Combatant.from_player(player)


static func sides(player: PlayerState) -> Array[Combatant]:
	return [player_combatant(player), enemy()]
