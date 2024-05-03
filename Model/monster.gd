class_name Monster extends Creature

var savingThrowDC: int
var monster: MonsterType
var size
var dice: Dice = Dice.new()
var tween = Tween.new()
@onready var attack_anim: AnimationPlayer = $AttackAnim

func _init(m: MonsterType):
	monster = m
	displayName = m.displayName
	hitPoints = dice.roll(m.hpRoll)
	savingThrowDC = m.armorClass
	hitPointsMaximum = hitPoints
	size = m.sizeCategory

# Called when the node enters the scene tree for the first time.
func _ready():
	if size == monster.SizeCategory.HUGE:
		get_parent().get_node("Hp").scale = Vector2(2,2)
	get_parent().texture = monster.bodySprite
	attack_anim = get_parent().get_node("AttackAnim")
	get_parent().get_node("Label").text = displayName
	get_parent().get_node("Hp").maxHealth = hitPointsMaximum
	get_parent().self_modulate = Color(1,1,1)
	get_parent().get_node("Hp").currentHealth = hitPoints
	get_parent().get_node("Armor").text = str(savingThrowDC)
	tween.stop()
	tween = create_tween()
	get_parent().global_position.x = 1250
	get_parent().rotation_degrees = -180
	tween.tween_property(get_parent(), "position:x", 551.0, 0.8).set_trans(Tween.TRANS_QUAD)

func takeDamage():
	get_parent().get_node("Hp").currentHealth = hitPoints

func dealDamage():
	var dmg = dice.roll(monster.weaponType.dmgRoll)
	return dmg

func hit(character: Character):
	#var dmg = dice.roll(monster.weaponType.dmgRoll)
#	character.reactToDamage(dmg)
#	character.takeDamage()
	attack_anim.play("attackAnim")
	#attack_anim.connect("animation_finished", _animationDone.bind(character, dmg))

#func _animationDone(character: Character, dmg: int):
	#character.reactToDamage(dmg)
	#character.takeDamage()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

