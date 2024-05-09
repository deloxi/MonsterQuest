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
@export var health: int
@export var strength: int
@export var dexterity: int
@export var constitution: int
@export var intelligence: int
@export var wisdom: int
@export var charisma: int
