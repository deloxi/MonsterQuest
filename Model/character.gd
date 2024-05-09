class_name Character extends Creature


var strength: int = dice.roll("4d6", true)
var dexterity: int = dice.roll("4d6", true)
var constitution: int = dice.roll("4d6", true)
var intelligence: int = dice.roll("4d6", true)
var wisdom: int = dice.roll("4d6", true)
var charisma: int = dice.roll("4d6", true)
var charType: CharacterType

@export var bodySprite: Texture
@onready var attack_anim: AnimationPlayer
# c: CharacterType
func _init(name: String,c: CharacterType, health = 30) -> void:
	displayName = name
	hitPoints = health
	hitPointsMaximum = health
	bodySprite = c.bodySprite
	weaponType = c.weaponType
	armorType = c.armorType
	#charType = c
	c.health = health
	c.strength = strength
	c.dexterity = dexterity
	c.constitution = constitution
	c.intelligence = intelligence
	c.wisdom = wisdom
	c.charisma = charisma
	
	print(name)
	
func _ready() -> void:
	get_parent().texture = bodySprite
	#match bodySprite:
		#"Assassin":
			##bodySprite.get_node("res://sprites/Assassin.png").set_texture()
			#get_parent().texture = load("res://sprites/Assassin.png")
		#"Mage":
			#get_parent().texture = load("res://sprites/Mage.png")
			##bodySprite.get_node("res://sprites/Mage.png").set_texture()
		#"Paladin":
			#get_parent().texture = load("res://sprites/Paladin.png")
			##bodySprite.get_node("res://sprites/Paladin.png").set_texture()
		#"Warrior":
			#get_parent().texture = load("res://sprites/Warrior.png")
			##bodySprite.get_node("res://sprites/Warrior.png").set_texture()
		#"Wizard":
			#get_parent().texture = load("res://sprites/Wizard.png")
			##bodySprite.get_node("res://sprites/Wizard.png").set_texture()
		#_:
			#get_parent().texture = load("res://sprites/Bat.png")
			##bodySprite.get_node("res://sprites/Bat.png").set_texture()
	attack_anim = get_parent().get_node("AttackAnim")
	get_parent().get_node("Label").text = displayName
	get_parent().get_node("Hp").maxHealth = hitPointsMaximum
	get_parent().get_node("Hp").currentHealth = hitPoints

func takeDamage():
	get_parent().get_node("Hp").currentHealth = hitPoints

func hit():
	attack_anim.play("attackAnim")
