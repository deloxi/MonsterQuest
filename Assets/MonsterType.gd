class_name MonsterType extends Resource

enum SizeCategory { SMALL, MEDIUM, LARGE, HUGE }

@export var displayName: String = "Monster"
@export var sizeCategory: SizeCategory = SizeCategory.MEDIUM
@export var hpRoll: String = "1d6"
@export var armorClass: int = 12
@export var armorType: ArmorType
@export var weaponType: WeaponType
@export var WeaponsList: Array[WeaponType] = []
@export var bodySprite: Texture
@export var abilityScores : AbilityScores
