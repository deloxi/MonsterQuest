class_name Creature extends Sprite2D

var displayName: String
var hitPoints: int
var hitPointsMaximum: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var node = get_node(".")
	print(node.name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reactToDamage(damageAmount: int):
	hitPoints -= damageAmount
	if hitPoints < 0:
		hitPoints = 0

func attackTarget(damageAmount: int, target: Creature):
	#$AttackDelay.start(1)
	target.reactToDamage(damageAmount)
	
func die():
	pass
