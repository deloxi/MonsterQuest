extends Node2D

var maxHealth: float
var currentHealth: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#maxHealth = get_parent()
	pass

func _process(delta: float) -> void:
	#print(currentHealth)
	var ratio = 330*(1-currentHealth/maxHealth)
	$Mask.offset.y = ratio

func hpUpdate():
	print(currentHealth)
	print(maxHealth)
	var ratio = 330*(1-currentHealth/maxHealth)
	$Mask.offset.y = ratio
