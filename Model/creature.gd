class_name Creature extends Sprite2D

var displayName: String
var hitPoints: int
var hitPointsMaximum: int
var savingRolls: int = 0
var maxSavingRolls: int = 3
var deathRolls: int = 0
var maxDeathRolls: int = 3
var lifeStatus: LifeStatusType = preload("res://Assets/Database/States/Conscious.tres")
const LIFE_SAVING_THROW = preload("res://life_saving_throw.tscn")
const DEATH_SAVING_THROW = preload("res://death_saving_throw.tscn")
@onready var dice_label = $DiceSprite/DiceLabel
@onready var dice_toss = $DiceSprite/DiceToss
var weaponType: WeaponType = preload("res://Assets/Database/Items/Weapons/Greataxe.tres") ## THIS MESSES UP DRAGON WEAPON
@onready var armorType: ArmorType
var dice = Dice.new()

func _ready() -> void:
	var node = get_node(".")
	print(node.name)

func _process(delta: float) -> void:
	pass

func reactToDamage(damageAmount: int):
	hitPoints -= damageAmount
	if hitPoints < 0:
		hitPoints = 0
	get_parent().get_node("Hp").currentHealth = hitPoints	

func attackTarget(dmg:int, target: Creature):
	target.reactToDamage(dmg)
	
	
func smartActions(target: Creature):
	var dmg = dice.roll(weaponType.dmgRoll)
	
	if hitPoints > 0:
		attackTarget(dmg, target)
	elif hitPoints == 0:
		deathSaveRoll()
	return dmg
	
func deathSaveRoll():
	randomize()
	var roll = randi_range(1,20)
	var saveThrowBox = get_parent().get_node("SaveThrowBox")
	get_parent().get_node("DiceSprite/DiceLabel").text = str(roll)
	get_parent().get_node("DiceSprite/DiceToss").play("dice_toss")
	
	if roll == 1:
		deathRolls += 2
		saveThrowBox.add_child(DEATH_SAVING_THROW.instantiate())
		saveThrowBox.add_child(DEATH_SAVING_THROW.instantiate())
	elif roll == 20:
		savingRolls += 2
		saveThrowBox.add_child(LIFE_SAVING_THROW.instantiate())
		saveThrowBox.add_child(LIFE_SAVING_THROW.instantiate())
	elif roll > 10:
		savingRolls += 1
		saveThrowBox.add_child(LIFE_SAVING_THROW.instantiate())
	elif roll <= 10:
		deathRolls += 1
		saveThrowBox.add_child(DEATH_SAVING_THROW.instantiate())
		
	if savingRolls >= 3:
		lifeStatus = preload("res://Assets/Database/States/Conscious.tres")
		hitPoints = 2
		deathRolls = 0
		savingRolls = 0
		get_parent().get_node("Hp").currentHealth = hitPoints
		get_parent().self_modulate = Color(1,1,1)
		for n in get_parent().get_node("SaveThrowBox").get_children():
			remove_child(n)
			n.queue_free()
		
	elif deathRolls >= 3:
		lifeStatus = preload("res://Assets/Database/States/Dead.tres")
		get_parent().self_modulate = Color(0,0,0)
		
		
		
func _on_animation_finished():
	print("animation finished haha")
