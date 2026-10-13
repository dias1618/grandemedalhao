class_name EnterScene
extends RefCounted

## Writes GameState.current_scene_id when the id is known.
## An unknown id is refused and the field stays as it was.
## Does not write world flags, mission, player scene, or game mode.


static func enter(state: GameState, scene_id: String) -> bool:
	if not SceneId.is_known(scene_id):
		return false
	state.current_scene_id = scene_id
	return true
