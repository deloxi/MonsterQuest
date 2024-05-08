class_name SaveGame extends Resource

const SAVE_GAME_PATH: String = "user://save.tres"

@export var currentCharacterList: Array[CharacterType] = []
@export var currentMonsterList: Array[MonsterType] = []



func write_savegame() -> void:
	ResourceSaver.save(self, SAVE_GAME_PATH)
	

#static func save_exists() -> bool:
#	return ResourceLoader.exists(SAVE_GAME_PATH)
	
static func load_savegame() -> Resource:
	if ResourceLoader.exists(SAVE_GAME_PATH):
		return load(SAVE_GAME_PATH)
	return null
