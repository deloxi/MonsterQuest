class_name CombatManager extends Node2D

@onready var monster_slot: Sprite2D = $MonsterSlot
var	consoleRef: PanelContainer
var attackDelay: Timer
var tween = Tween.new()
#var dice = Dice.new()

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
		
		var order = initiativeOrder(monster, gameState.party.partyList)
		
		while gameState.party.partyList.size() > 0:
			for creature in order:
				#print(creature.get_child().get_class())
				if (creature is Character) && !creature.lifeStatus.isDead:
					
					
					if creature.lifeStatus.canAttack:	
						creature.hit()
					
					attackDelay.one_shot = true
					attackDelay.start(1.0)
					await nextPlayer
					
					#var damage = Dice.rollWithDice(1,5,1)
					
					var damage = creature.smartActions(monster)
					#creature.attackTarget(5, monster) ## MARK HERE
					
					if monster.hitPoints > 0 && creature.lifeStatus.canAttack:
						print(creature.weaponType.displayName)
						consoleRef.printLine(creature.displayName + " hits the " + monster.displayName + " for " + str(damage) +  " damage with " + creature.weaponType.displayName + ", " + monster.displayName + " has " + str(monster.hitPoints) + " HP left.")
				
					elif monster.hitPoints <= 0 && creature.lifeStatus.canAttack:
						consoleRef.printLine(creature.displayName + " hits the " + monster.displayName + " for " + str(damage) + " damage which kills it using " + creature.weaponType.displayName)
						break
						
				if monster.hitPoints <= 0:
					#monster.takeDamage()
					break
						
				elif creature is Monster:
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
					monster.hit(targetName) ## REMOVE TARGETNAME HERE AND IN MONSTERS
			
					await nextPlayer
					attackDelay.one_shot = true
					attackDelay.start(0.1)
					
					monster.smartActions(targetName)
					#monster.attackTarget(targetName)
					
										
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



					if targetName.lifeStatus == preload("res://Assets/Database/States/Unconscious.tres"):
						targetName.deathSaveRoll()

						if targetName.deathRolls >= 3:
							targetName.get_parent().self_modulate = Color(0,0,0)				
							gameState.party.partyList.erase(targetName) ## ADD THIS BACK IF NOT WORKING
						
					elif targetName.hitPoints <= 0:
						consoleRef.printLine(targetName.displayName + " was knocked unconscious.")
						await nextPlayer
						targetName.get_parent().self_modulate = Color(1,0,0)
						targetName.lifeStatus = preload("res://Assets/Database/States/Unconscious.tres")
						print(targetName.lifeStatus.displayName)
						#gameState.party.partyList.erase(targetName) ## ADD THIS BACK IF NOT WORKING
					else:
						await nextPlayer
				if creature.lifeStatus.isDead:
					order.erase(creature)
					gameState.party.partyList.erase(creature)
					consoleRef.printLine(creature.displayName + " died")

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
	

func initiativeOrder(monster: Monster, party: Array) -> Array:
	var randomizedOrder = []
	
	randomizedOrder.append(monster)
	for member in party:
		randomizedOrder.append(member) 
	
	randomizedOrder.shuffle()
	return randomizedOrder
	
