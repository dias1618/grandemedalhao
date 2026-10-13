class_name SceneId
extends RefCounted

## Vertical-slice scene ids. The only accepted texts are outside, bar, and pirate_cave.

const IDS: Array[String] = ["outside", "bar", "pirate_cave"]


static func is_known(id: String) -> bool:
	return id in IDS


static func known_ids() -> Array[String]:
	return IDS.duplicate()
