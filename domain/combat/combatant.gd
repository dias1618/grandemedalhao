class_name Combatant
extends RefCounted

## Temporary battle copy. It does not start a fight or write back to the player.


const SIDE_PLAYER := "player"
const SIDE_ENEMY := "enemy"

const SIDES: Array[String] = [SIDE_PLAYER, SIDE_ENEMY]

var id: String = ""

var side: String = "":
	set(value):
		if value not in SIDES:
			return
		side = value

var hp: int = 0:
	set(value):
		if value < 0:
			return
		hp = value

var max_hp: int = 0
var energy: int = 0
var strength: int = 0
var defense: int = 0
var speed: int = 0
var luck: int = 0


static func from_player(player: PlayerState) -> Combatant:
	var combatant := Combatant.new()
	combatant.id = player.character_id
	combatant.side = SIDE_PLAYER
	combatant.hp = player.hp
	combatant.max_hp = player.hp
	combatant.energy = player.energy
	combatant.strength = player.strength
	combatant.defense = player.defense
	combatant.speed = player.speed
	combatant.luck = player.luck
	return combatant


func is_defeated() -> bool:
	return hp == 0
