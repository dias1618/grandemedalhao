class_name MissionState
extends RefCounted

## The old man's daughter mission before any accept transition.
## A null mission reads as not_started. There is no route.


const ID := "old_man_daughter"
const NOT_STARTED := "not_started"
const ACCEPTED := "accepted"

const STAGES: Array[String] = [NOT_STARTED, ACCEPTED]

var id: String = ID:
	set(value):
		if value != ID:
			return
		id = value

var stage: String = NOT_STARTED:
	set(value):
		if value not in STAGES:
			return
		stage = value


static func create(stage: String = NOT_STARTED) -> MissionState:
	if stage not in STAGES:
		return null
	var mission := MissionState.new()
	mission.stage = stage
	return mission


static func stage_of(mission: Variant) -> String:
	if mission is MissionState:
		return (mission as MissionState).stage
	return NOT_STARTED
