extends Node
class_name GameState

var party = Party
var monsters = []

func _init(currentParty: Party, currentMonster: Array ):
	party = currentParty
	monsters = currentMonster

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


#func gameState(party: Party):
#	pass
	
#func enterCombatWithMonster(monster: Monster):
#	pass
