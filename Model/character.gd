class_name Character extends Creature


var strength: int = dice.roll("3d6+1")
var dexterity: int = dice.roll("3d6+1")
var constitution: int = dice.roll("3d6+1")
var intelligence: int = dice.roll("3d6+1")
var wisdom: int = dice.roll("3d6+1")
var charisma: int = dice.roll("3d6+1")

@export var bodySprite: String
@onready var attack_anim: AnimationPlayer


func _init(name: String, charClass: String, weapon: WeaponType, armor: ArmorType, health = 30) -> void:
	displayName = name
	hitPoints = health
	hitPointsMaximum = health
	bodySprite = charClass
	weaponType = weapon
	armorType = armor
	print(name)
	
func _ready() -> void:
	match bodySprite:
		"Assassin":
			#bodySprite.get_node("res://sprites/Assassin.png").set_texture()
			get_parent().texture = load("res://sprites/Assassin.png")
		"Mage":
			get_parent().texture = load("res://sprites/Mage.png")
			#bodySprite.get_node("res://sprites/Mage.png").set_texture()
		"Paladin":
			get_parent().texture = load("res://sprites/Paladin.png")
			#bodySprite.get_node("res://sprites/Paladin.png").set_texture()
		"Warrior":
			get_parent().texture = load("res://sprites/Warrior.png")
			#bodySprite.get_node("res://sprites/Warrior.png").set_texture()
		"Wizard":
			get_parent().texture = load("res://sprites/Wizard.png")
			#bodySprite.get_node("res://sprites/Wizard.png").set_texture()
		_:
			get_parent().texture = load("res://sprites/Bat.png")
			#bodySprite.get_node("res://sprites/Bat.png").set_texture()
	attack_anim = get_parent().get_node("AttackAnim")
	get_parent().get_node("Label").text = displayName
	get_parent().get_node("Hp").maxHealth = hitPointsMaximum
	get_parent().get_node("Hp").currentHealth = hitPoints

func takeDamage():
	get_parent().get_node("Hp").currentHealth = hitPoints

func hit():
	attack_anim.play("attackAnim")
