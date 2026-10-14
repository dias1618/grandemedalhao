extends RefCounted

const DialogueLineScript := preload("res://domain/dialogue/dialogue_line.gd")
const OldManConversationScript := preload("res://domain/dialogue/old_man_conversation.gd")

const SNIFF_LINE := "Sniff.... Sniff.... Não sei o que fazer agora, minha pequena foi levada por aqueles fdp."
const CRYING_LINE := "Não cai bem para alguém da sua idade estar chorando assim..."
const RESCUE_LINE := "Você diz isso por que não deve ter filhos, não há tristeza maior... você parece um jovem forte, me ajude a resgata-la."
const STRANGER_LINE := "Se é algo importante pra você não deveria deixar nas mãos de um estranho, nem que levassem seus braços e pernas você deveria toma-la de volta custe o que custar"
const DESPAIR_LINE := "Pedir ajuda a um estranho como você é a prova do meu desespero... acha que não tentei resgata-la? Acha que eu deixaria minha menina ir sem fazer nada? Tomei uma surra deles, e só estou vivo por que querem me ver humilhado... meu corpo não tem mais nenhuma força.... sozinho não consigo fazer mais nada...."
const CHOICE_QUESTION := "Você irá atrás dos bandidos?"


func run() -> bool:
	if not _first_line_is_the_sniff_and_fifth_is_the_despair():
		return false
	if not _all_five_lines_match_the_written_wording():
		return false
	if not _sequence_stops_after_five_lines():
		return false
	if not _normal_line_with_empty_speaker_is_rejected():
		return false
	if not _narration_without_portrait_is_accepted():
		return false
	return _thought_may_name_zoro()


func _first_line_is_the_sniff_and_fifth_is_the_despair() -> bool:
	if OldManConversationScript.ID != "old_man_conversation":
		return false
	var sequence: Array = OldManConversationScript.lines()
	if sequence.size() != 5:
		return false
	var first: RefCounted = sequence[0]
	var fifth: RefCounted = sequence[4]
	if first.get("speaker") != "old_man" or first.get("portrait") != "old_man":
		return false
	if first.get("text") != SNIFF_LINE or first.get("type") != "normal":
		return false
	if fifth.get("speaker") != "old_man" or fifth.get("portrait") != "old_man":
		return false
	if fifth.get("text") != DESPAIR_LINE or fifth.get("type") != "normal":
		return false
	var speakers: Array[String] = ["old_man", "zoro", "old_man", "zoro", "old_man"]
	for index in sequence.size():
		var line: RefCounted = sequence[index]
		if line.get("type") != "normal":
			return false
		if line.get("speaker") != speakers[index]:
			return false
		if line.get("portrait") != speakers[index]:
			return false
		if str(line.get("text")).contains(CHOICE_QUESTION):
			return false
	return true


func _all_five_lines_match_the_written_wording() -> bool:
	var expected: Array[String] = [
		SNIFF_LINE,
		CRYING_LINE,
		RESCUE_LINE,
		STRANGER_LINE,
		DESPAIR_LINE,
	]
	var sequence: Array = OldManConversationScript.lines()
	if sequence.size() != expected.size():
		return false
	for index in expected.size():
		var line: RefCounted = sequence[index]
		if line.get("text") != expected[index]:
			return false
		if line.get("text") == CHOICE_QUESTION:
			return false
	return true


func _sequence_stops_after_five_lines() -> bool:
	var sequence: Array = OldManConversationScript.lines()
	if sequence.size() != 5:
		return false
	var seen := 0
	var current: Variant = sequence[0]
	while current != null:
		seen += 1
		if seen > 5:
			return false
		if current != sequence[seen - 1]:
			return false
		current = current.get("next")
	if seen != 5:
		return false
	return sequence[4].get("next") == null


func _normal_line_with_empty_speaker_is_rejected() -> bool:
	if DialogueLineScript.create("", "texto", "normal") != null:
		return false
	if DialogueLineScript.create("", "texto", "normal", "old_man") != null:
		return false
	var line: RefCounted = DialogueLineScript.create("old_man", "texto", "normal", "old_man")
	if line == null:
		return false
	line.set("speaker", "")
	if line.get("speaker") != "old_man":
		return false
	var blank: RefCounted = DialogueLineScript.new()
	blank.set("type", "normal")
	if blank.get("type") == "normal":
		return false
	if blank.get("speaker") != "":
		return false
	return DialogueLineScript.create("zoro", "texto", "other") == null


func _narration_without_portrait_is_accepted() -> bool:
	var line: RefCounted = DialogueLineScript.create("", "A noite cai.", "narration")
	if line == null:
		return false
	if line.get("type") != "narration":
		return false
	if line.get("portrait") != "":
		return false
	return line.get("next") == null


func _thought_may_name_zoro() -> bool:
	var line: RefCounted = DialogueLineScript.create("zoro", "Onde está a garota?", "thought")
	if line == null:
		return false
	if line.get("speaker") != "zoro":
		return false
	return line.get("type") == "thought"
