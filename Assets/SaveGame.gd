class_name SaveGame extends Resource

const SAVE_GAME_PATH: String = "user://save.tres"

#@export var currentCharacterList: CharacterType #Array[CharacterType] = []
#@export var currentMonsterList: MonsterType #Array[MonsterType] = []

@export var p1Name: String
@export var p1Health: int
@export var p1HealthMaximum: int
@export var p1Strength: int
@export var p1Dexterity: int
@export var p1Constitution: int
@export var p1Intelligence: int
@export var p1Wisdom: int
@export var p1Charisma: int
@export var string1 = "-------"
@export var p2Name: String
@export var p2Health: int
@export var p2HealthMaximum: int
@export var p2Strength: int
@export var p2Dexterity: int
@export var p2Constitution: int
@export var p2Intelligence: int
@export var p2Wisdom: int
@export var p2Charisma: int
@export var string2 = "-------"
@export var p3Name: String
@export var p3Health: int
@export var p3HealthMaximum: int
@export var p3Strength: int
@export var p3Dexterity: int
@export var p3Constitution: int
@export var p3Intelligence: int
@export var p3Wisdom: int
@export var p3Charisma: int
@export var string3 = "-------"
@export var p4Name: String
@export var p4Health: int
@export var p4HealthMaximum: int
@export var p4Strength: int
@export var p4Dexterity: int
@export var p4Constitution: int
@export var p4Intelligence: int
@export var p4Wisdom: int
@export var p4Charisma: int
@export var string4 = "-------"
@export var mName: String
@export var mHealth: int
@export var mHealthMaximum: int
@export var mStrength: int
@export var mDexterity: int
@export var mConstitution: int
@export var mIntelligence: int
@export var mWisdom: int
@export var mCharisma: int
@export var string5 = "-------"
@export var m2Name: String
@export var m2Health: int
@export var m2HealthMaximum: int
@export var m2Strength: int
@export var m2Dexterity: int
@export var m2Constitution: int
@export var m2Intelligence: int
@export var m2Wisdom: int
@export var m2Charisma: int
@export var string6 = "-------"
@export var m3Name: String
@export var m3Health: int
@export var m3HealthMaximum: int
@export var m3Strength: int
@export var m3Dexterity: int
@export var m3Constitution: int
@export var m3Intelligence: int
@export var m3Wisdom: int
@export var m3Charisma: int


func write_savegame() -> void:
	ResourceSaver.save(self, SAVE_GAME_PATH)
	print("Save successful")

static func save_exists() -> bool:
	print (SAVE_GAME_PATH)	
	return ResourceLoader.exists(SAVE_GAME_PATH)
	
	
static func load_savegame() -> Resource:
	if ResourceLoader.exists(SAVE_GAME_PATH):
		print("Load successful")	
		return load(SAVE_GAME_PATH)
	return null
