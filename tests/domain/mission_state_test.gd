extends RefCounted

const MissionStateScript := preload("res://domain/mission/mission_state.gd")
const GameStateScript := preload("res://domain/state/game_state.gd")


func run() -> bool:
	if not _new_mission_is_not_started():
		return false
	if not _null_mission_reads_as_not_started():
		return false
	if not _fresh_session_leaves_mission_null():
		return false
	return _invalid_stage_is_rejected()


func _new_mission_is_not_started() -> bool:
	var mission: RefCounted = MissionStateScript.new()
	if mission.get("id") != "old_man_daughter":
		return false
	if mission.get("stage") != "not_started":
		return false
	if "route" in mission or "completed_events" in mission:
		return false
	var created: Variant = MissionStateScript.create()
	if created == null or created.get("stage") != MissionStateScript.NOT_STARTED:
		return false
	if created.get("id") != MissionStateScript.ID:
		return false
	var accepted: Variant = MissionStateScript.create(MissionStateScript.ACCEPTED)
	if accepted == null or accepted.get("id") != "old_man_daughter":
		return false
	return MissionStateScript.stage_of(accepted) == "accepted"


func _null_mission_reads_as_not_started() -> bool:
	if MissionStateScript.stage_of(null) != MissionStateScript.NOT_STARTED:
		return false
	var session: RefCounted = GameStateScript.new()
	return MissionStateScript.stage_of(session.get("mission")) == "not_started"


func _fresh_session_leaves_mission_null() -> bool:
	var session: RefCounted = GameStateScript.new()
	return session.get("mission") == null


func _invalid_stage_is_rejected() -> bool:
	if MissionStateScript.create("cave") != null:
		return false
	if MissionStateScript.create("rescue") != null:
		return false
	if MissionStateScript.create("") != null:
		return false
	var mission: RefCounted = MissionStateScript.new()
	mission.set("stage", "cave_encounter")
	if mission.get("stage") != "not_started":
		return false
	mission.set("id", "other_mission")
	if mission.get("id") != "old_man_daughter":
		return false
	mission.set("stage", "accepted")
	if mission.get("stage") != "accepted":
		return false
	mission.set("stage", "alliance")
	return mission.get("stage") == "accepted"
