class_name OldManConversation
extends RefCounted

## The old man's first five spoken lines. The choice question is not part of this data.


const ID := "old_man_conversation"

const _SPEAKERS: Array[String] = ["old_man", "zoro", "old_man", "zoro", "old_man"]
const _PORTRAITS: Array[String] = ["old_man", "zoro", "old_man", "zoro", "old_man"]
const _TEXTS: Array[String] = [
	"Sniff.... Sniff.... Não sei o que fazer agora, minha pequena foi levada por aqueles fdp.",
	"Não cai bem para alguém da sua idade estar chorando assim...",
	"Você diz isso por que não deve ter filhos, não há tristeza maior... você parece um jovem forte, me ajude a resgata-la.",
	"Se é algo importante pra você não deveria deixar nas mãos de um estranho, nem que levassem seus braços e pernas você deveria toma-la de volta custe o que custar",
	"Pedir ajuda a um estranho como você é a prova do meu desespero... acha que não tentei resgata-la? Acha que eu deixaria minha menina ir sem fazer nada? Tomei uma surra deles, e só estou vivo por que querem me ver humilhado... meu corpo não tem mais nenhuma força.... sozinho não consigo fazer mais nada....",
]


static func lines() -> Array[DialogueLine]:
	var fifth := _line(4, null)
	var fourth := _line(3, fifth)
	var third := _line(2, fourth)
	var second := _line(1, third)
	var first := _line(0, second)
	var sequence: Array[DialogueLine] = [first, second, third, fourth, fifth]
	return sequence


static func _line(index: int, next_line: DialogueLine) -> DialogueLine:
	return DialogueLine.create(
		_SPEAKERS[index],
		_TEXTS[index],
		DialogueLine.NORMAL,
		_PORTRAITS[index],
		next_line
	)
