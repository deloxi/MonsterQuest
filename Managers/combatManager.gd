class_name CombatManager extends Node2D

@onready var monster_slot: Sprite2D = $MonsterSlot
var	consoleRef: PanelContainer
var attackDelay: Timer
var tween = Tween.new()
signal nextPlayer
#func _init(consoleNode):
#	consoleRef = consoleNode
	
# Called when the node enters the scene tree for the first time.
func _ready():
	consoleRef = $"../Console"
	attackDelay = Timer.new()
	attackDelay.connect("timeout", _onNextPlayer)
	add_child(attackDelay)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _onNextPlayer():
	nextPlayer.emit("Go go go")
	pass

#func SimulateBattle(names, monster: String, monsterHP: int, savingThrowDC: int):
func SimulateBattle(gameState: GameState):
	
	var monsters = gameState.monsters
	
	var fixedNames = stringHelper.joinWithAnd(gameState.party.partyList)
	#var fixedNames = stringHelper.joinWithAnd(names)
	consoleRef.printLine("A party of warriors "+ str(fixedNames) +" decends into the dungeon")
	
	for monster in monsters:
		consoleRef.printLine("A "+monster.displayName + " with "+ str(monster.hitPoints) + " HP appears")
		monster_slot.add_child(monster)
		
		while gameState.party.partyList.size() > 0:
			for name in gameState.party.partyList:
				attackDelay.one_shot = true
				attackDelay.start(1.0)
				name.hit()
				await nextPlayer

				var damage = Dice.rollWithDice(1,5,1)
				monster.reactToDamage(damage)
				monster.takeDamage()
				
				if monster.hitPoints > 0:
					print(name.weaponType.displayName)
					consoleRef.printLine(name.displayName + " hits the " + monster.displayName + " for " + str(damage) +  " damage with " + name.weaponType.displayName + ", " + monster.displayName + " has " + str(monster.hitPoints) + " HP left.")
			
				elif monster.hitPoints <= 0:
					consoleRef.printLine(name.displayName + " hits the " + monster.displayName + " for " + str(damage) + " damage which kills it using " + name.weaponType.displayName)
					break

			if monster.hitPoints <= 0:
				#monster.takeDamage()
				break
		
			#attackDelay.one_shot = true
			#attackDelay.start(1.0)
			#monster.hit()
			
			var targetIndex = Dice.rollWithDice(1,gameState.party.partyList.size(),0)
			var targetName = gameState.party.partyList[targetIndex-1]
			
			var targetPos = targetName.get_parent().global_position
			var monsterPos = monster.get_parent().global_position
			var direction = targetPos-monsterPos
			var angle = atan2(direction.y, direction.x)
			var degrees = rad_to_deg(angle)
			#print(degrees)
			var calc = degrees-90
			#print(targetName.displayName +" " +str(calc))
			#monster.get_parent().rotation = degrees-90
			var sp = monster.get_parent()
			#sp.rotation_degrees = calc
			
			attackDelay.one_shot = true
			attackDelay.start(0.7)
			
			tween.stop()
			tween = create_tween()
			tween.tween_property(sp, "rotation_degrees", calc, 0.7).set_trans(Tween.TRANS_QUAD)
			
			await nextPlayer
			
			attackDelay.one_shot = true
			attackDelay.start(1.0)
			#print(targetName.displayName +" has "+ str(targetName.hitPoints))
			monster.hit(targetName) ## REMOVE TARGETNAME HERE AND IN MONSTERS
			#print(targetName.displayName +" has "+ str(targetName.hitPoints))
	
			await nextPlayer
			attackDelay.one_shot = true
			attackDelay.start(0.1)
			targetName.reactToDamage(monster.dealDamage())
			targetName.takeDamage()
								
			consoleRef.printLine("The " + monster.displayName + " attacks " + targetName.displayName + "!")

			#var constitution = 5
			#var saveRoll = Dice.rollWithDice(1,20,0)
#
			#if constitution + saveRoll > monster.savingThrowDC:
				#consoleRef.printLine(targetName.displayName + " rolls a " + str(saveRoll) + " and is saved from the attack.")
				#await nextPlayer
			#else:
				#consoleRef.printLine(targetName.displayName + " rolls a " + str(saveRoll) + " and died a painful death.")
				#await nextPlayer
				#targetName.get_parent().self_modulate = Color(1,0,0)
			#	gameState.party.partyList.erase(targetName) ## ADD THIS BACK IF NOT WORKING
				
			if targetName.hitPoints <= 0:
				consoleRef.printLine(targetName.displayName + " lost all health and died a painful death.")
				await nextPlayer
				targetName.get_parent().self_modulate = Color(1,0,0)
				gameState.party.partyList.erase(targetName) ## ADD THIS BACK IF NOT WORKING
			else:
				await nextPlayer

		if monster.hitPoints > 0:
			consoleRef.printLine("Your party has died and the " + monster.displayName + " will ravish the lands!")
			await nextPlayer
		else:
			var remainingNames = stringHelper.joinWithAnd(gameState.party.partyList)
			consoleRef.printLine("The " + monster.displayName + " collapses and " + remainingNames + " move on!")
			monster.get_parent().self_modulate = Color(1,0,0)
			monster_slot.remove_child(monster)
			attackDelay.one_shot = true
			attackDelay.start(2.0)
			await nextPlayer
	

