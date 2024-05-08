class_name CharacterType extends Resource

var dice = Dice.new()

@export var className: String = "Peasant"
#@export var hpRoll: String
#@export var armorClass: int
@export var armorType: ArmorType
@export var weaponType: WeaponType
#@export var WeaponsList: Array[WeaponType] = []
@export var bodySprite: Texture
#@export var abilityScores : AbilityScores

@export var health: int = 5
@export var strength: int = 5
@export var dexterity: int = 5
@export var constitution: int = 5
@export var intelligence: int = 5
@export var wisdom: int = 5
@export var charisma: int = 5
