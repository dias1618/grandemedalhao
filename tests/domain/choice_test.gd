extends RefCounted

const OldManHelpChoiceScript := preload("res://domain/choice/old_man_help_choice.gd")

const PROMPT := "Você irá atrás dos bandidos?"
const WALK_LINE := "Vou dar uma volta, quem sabe não encontre alguns bandidos para testar minha lâmina nova. Me aponte onde posso achar algumas cobaias, velho"
const CAVE_LINE := "Em uma caverna a nordeste daqui, encrustada em uma montanha, e logo após um pequeno lago... não sei como lhe pagar meu jovem..."
const KNOW_LINE := "Você saberá..."
const WAIT_LINE := "Quem sabe uma hora minha lâmina decida brincar com esses bandidos, por ora terá de aguardar ai, velho"


func run() -> bool:
	if not _prompt_and_labels_are_exposed():
		return false
	if not _accept_returns_three_chained_lines():
		return false
	if not _refuse_returns_one_line_without_next():
		return false
	return _unknown_option_returns_no_lines()


func _prompt_and_labels_are_exposed() -> bool:
	if OldManHelpChoiceScript.ID != "old_man_help":
		return false
	if OldManHelpChoiceScript.PROMPT != PROMPT:
		return false
	if OldManHelpChoiceScript.label_for("accept") != "Sim":
		return false
	return OldManHelpChoiceScript.label_for("refuse") == "Não"


func _accept_returns_three_chained_lines() -> bool:
	var lines: Array = OldManHelpChoiceScript.lines_for("accept")
	if lines.size() != 3:
		return false
	var expected_speakers: Array[String] = ["zoro", "old_man", "zoro"]
	var expected_texts: Array[String] = [WALK_LINE, CAVE_LINE, KNOW_LINE]
	for index in lines.size():
		var line: RefCounted = lines[index]
		if line.get("speaker") != expected_speakers[index]:
			return false
		if line.get("portrait") != expected_speakers[index]:
			return false
		if line.get("text") != expected_texts[index]:
			return false
		if line.get("type") != "normal":
			return false
		if index < lines.size() - 1 and line.get("next") != lines[index + 1]:
			return false
	return lines[2].get("next") == null


func _refuse_returns_one_line_without_next() -> bool:
	var lines: Array = OldManHelpChoiceScript.lines_for("refuse")
	if lines.size() != 1:
		return false
	var line: RefCounted = lines[0]
	if line.get("speaker") != "zoro" or line.get("portrait") != "zoro":
		return false
	if line.get("text") != WAIT_LINE or line.get("type") != "normal":
		return false
	return line.get("next") == null


func _unknown_option_returns_no_lines() -> bool:
	if OldManHelpChoiceScript.lines_for("cave").size() != 0:
		return false
	if OldManHelpChoiceScript.lines_for("").size() != 0:
		return false
	if OldManHelpChoiceScript.lines_for("Sim").size() != 0:
		return false
	return OldManHelpChoiceScript.label_for("cave") == ""
