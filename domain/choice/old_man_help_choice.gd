class_name OldManHelpChoice
extends RefCounted

## The old man's yes/no question and the replies spoken after it.
## Accepting or refusing does not change the mission.


const ID := "old_man_help"
const PROMPT := "Você irá atrás dos bandidos?"
const ACCEPT := "accept"
const REFUSE := "refuse"

const _ACCEPT_LABEL := "Sim"
const _REFUSE_LABEL := "Não"

const _ACCEPT_SPEAKERS: Array[String] = ["zoro", "old_man", "zoro"]
const _ACCEPT_PORTRAITS: Array[String] = ["zoro", "old_man", "zoro"]
const _ACCEPT_TEXTS: Array[String] = [
	"Vou dar uma volta, quem sabe não encontre alguns bandidos para testar minha lâmina nova. Me aponte onde posso achar algumas cobaias, velho",
	"Em uma caverna a nordeste daqui, encrustada em uma montanha, e logo após um pequeno lago... não sei como lhe pagar meu jovem...",
	"Você saberá...",
]

const _REFUSE_SPEAKER := "zoro"
const _REFUSE_PORTRAIT := "zoro"
const _REFUSE_TEXT := "Quem sabe uma hora minha lâmina decida brincar com esses bandidos, por ora terá de aguardar ai, velho"


static func label_for(option_id: String) -> String:
	if option_id == ACCEPT:
		return _ACCEPT_LABEL
	if option_id == REFUSE:
		return _REFUSE_LABEL
	return ""


static func lines_for(option_id: String) -> Array[DialogueLine]:
	if option_id == ACCEPT:
		return _chain(_ACCEPT_SPEAKERS, _ACCEPT_PORTRAITS, _ACCEPT_TEXTS)
	if option_id == REFUSE:
		return _chain([_REFUSE_SPEAKER], [_REFUSE_PORTRAIT], [_REFUSE_TEXT])
	var none: Array[DialogueLine] = []
	return none


static func _chain(
	speakers: Array[String],
	portraits: Array[String],
	texts: Array[String]
) -> Array[DialogueLine]:
	var sequence: Array[DialogueLine] = []
	sequence.resize(texts.size())
	var next_line: DialogueLine = null
	for index in range(texts.size() - 1, -1, -1):
		var line := DialogueLine.create(
			speakers[index],
			texts[index],
			DialogueLine.NORMAL,
			portraits[index],
			next_line
		)
		sequence[index] = line
		next_line = line
	return sequence
