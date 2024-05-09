class_name CombatManager extends Node2D

@onready var monster_slot: Sprite2D = $MonsterSlot
var	consoleRef: PanelContainer
var attackDelay: Timer
var tween = Tween.new()
#var dice = Dice.new()
var _save = SaveGame.new()
var party = []
var monsters = []
#var gameStartTurn = 1

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
	party = gameState.party
	monsters = gameState.monsters
	_create_or_load_save()
	
	
	for member in party:
		for i in range(member.savingRolls):
			member.lifeRollPrint()
		for i in range(member.deathRolls):
			member.deathRollPrint()
		
		if !member.lifeStatus.canAttack && !member.lifeStatus.isDead:
			member.get_parent().self_modulate = Color(1,0,0)
		elif member.lifeStatus.isDead:
			member.get_parent().self_modulate = Color(0,0,0)
	
	var fixedNames = stringHelper.joinWithAnd(party)
	#var fixedNames = stringHelper.joinWithAnd(names)
	consoleRef.printLine("A party of warriors "+ str(fixedNames) +" decends into the dungeon.")
	
	for monster in monsters:
		print(monster)		
		consoleRef.printLine("Watch out "+monster.displayName.to_lower() + " with "+ str(monster.hitPoints) + " HP appears.")
		monster_slot.add_child(monster)
		
		var order = initiativeOrder(monster, party)
		order.sort_custom(sortAscendingTurnOrder)
		for i in range((_save.currentTurn)-1):
			var tempVar = order.pop_front()
			order.push_back(tempVar)
		
		var currentTurn: int = 1
		_save.currentTurn = 1
		
		while monster.hitPoints > 0:
			for creature in order:
				if currentTurn > order.size():
					currentTurn = 1
				
				
				#print(creature.get_child().get_class())
				if (creature is Character) && !creature.lifeStatus.isDead && monster.hitPoints > 0:
					
					
					if creature.lifeStatus.canAttack:	
						creature.hit()
					
					attackDelay.one_shot = true
					attackDelay.start(1.0)
					await nextPlayer
					
					#var damage = Dice.rollWithDice(1,5,1)
					
					var damage = creature.smartActions(monster, creature.strength, creature.dexterity)
					#creature.attackTarget(5, monster) ## MARK HERE
					
					if monster.hitPoints > 0 && creature.lifeStatus.canAttack:
						print(creature.weaponType.displayName)
						consoleRef.printLine(creature.displayName + " hits the " + monster.displayName.to_lower() + " for " + str(damage) +  " damage with " + creature.weaponType.displayName.to_lower() + ", " + monster.displayName.to_lower() + " has " + str(monster.hitPoints) + " HP left.")
				
					elif monster.hitPoints <= 0 && creature.lifeStatus.canAttack:
						consoleRef.printLine(creature.displayName + " hits the " + monster.displayName.to_lower() + " for " + str(damage) + " damage which kills it using " + creature.weaponType.displayName.to_lower() + ".")
						break
						
				if monster.hitPoints <= 0:
					#monster.takeDamage()
					break
						
				if creature is Monster:
					var targetIndex
					var targetName: Character
					var targetLowestHp = 999
					var amountUnconscious = 0
					var copyTargetList = []
					
					if monster.monster.abilityScores.intelligence >= 10: ## creature instead
						for character in party:
								if character.hitPoints < targetLowestHp && character.hitPoints > 0 && !character.lifeStatus.isDead:
									targetName = character
									targetLowestHp = character.hitPoints
								else:
									amountUnconscious += 1
									if amountUnconscious >= party.size():
										var tempTarget = party.pick_random()
										while tempTarget.lifeStatus.isDead:
											print("trying new target")
											tempTarget = party.pick_random()
										
										targetName = tempTarget
										
										#targetIndex = Dice.rollWithDice(1,gameState.party.size(),0)
										#targetName = gameState.party[targetIndex-1]
										
										#copyTargetList = party
										#for copyCharacter in copyTargetList:
											#if copyCharacter.hitPoints < 1:
												#copyTargetList.erase(copyCharacter) 
								#
										#targetIndex = Dice.rollWithDice(1,copyTargetList.size(),0)
										#targetName = copyTargetList[targetIndex-1]
					else:
						var tempTarget = party.pick_random()
						var loopLimiter: int = 0
						while tempTarget.lifeStatus.isDead && loopLimiter < 20:
							print("trying new target")
							tempTarget = party.pick_random()
							loopLimiter += 1
							if !tempTarget.lifeStatus.isDead:
								break
					
						targetName = tempTarget
						
						
						#targetIndex = Dice.rollWithDice(1,gameState.party.size(),0)
						#targetName = gameState.party[targetIndex-1]
						
						#copyTargetList = party
						#for copyCharacter in copyTargetList:
							#if copyCharacter.hitPoints < 1:
								#copyTargetList.erase(copyCharacter) 
								#
						#targetIndex = Dice.rollWithDice(1,copyTargetList.size(),0)
						#targetName = copyTargetList[targetIndex-1]

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
					
					var damage = monster.smartActions(targetName, monster.monster.abilityScores.strength, monster.monster.abilityScores.dexterity)
					#monster.attackTarget(targetName)
					
										
					consoleRef.printLine("The " + monster.displayName.to_lower() + " attacks " + targetName.displayName + " for " + str(damage) + " damage!")

					

					if targetName.lifeStatus == preload("res://Assets/Database/States/Unconscious.tres"):
						targetName.deathSaveRoll()

					elif targetName.deathRolls >= 3:
						targetName.hitPoints = 0
						targetName.takeDamage()
						targetName.get_parent().self_modulate = Color(0,0,0)	
						targetName.lifeStatus = preload("res://Assets/Database/States/Dead.tres")
						order.erase(targetName)
						#gameState.party.erase(targetName) ## ADD THIS BACK IF NOT WORKING
						
					elif targetName.hitPoints <= 0:
						consoleRef.printLine(targetName.displayName + " was knocked unconscious.")
						await nextPlayer
						targetName.get_parent().self_modulate = Color(1,0,0)
						targetName.lifeStatus = preload("res://Assets/Database/States/Unconscious.tres")
						print(targetName.lifeStatus.displayName)
					else:
						await nextPlayer
				if creature.lifeStatus.isDead:
					creature.lifeStatus = preload("res://Assets/Database/States/Dead.tres")
					order.erase(creature)
					#gameState.party.erase(creature)
					consoleRef.printLine(creature.displayName + " died")
				
				creature.turnOrder = currentTurn
				currentTurn += 1
				_save.currentTurn = currentTurn
				_save_files()
				var deathChecks: int = 0
				for deadChar in party:
					if deadChar.lifeStatus.isDead:
						deathChecks += 1
				if deathChecks == party.size():
					break
				
		if monster.hitPoints > 0:
			consoleRef.printLine("Your party has died and the " + monster.displayName.to_lower() + " will ravish the lands!")
			await nextPlayer
		else:
			var remainingNames = stringHelper.joinWithAnd(party)
			consoleRef.printLine("The " + monster.displayName.to_lower() + " collapses and " + remainingNames + " move on!")
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
	
func sortAscendingTurnOrder(a, b):
	if a.turnOrder < b.turnOrder:
		return true
	return false

	pass
	
func _create_or_load_save() -> void:
	if SaveGame.save_exists(): ## loads from file
		_save = SaveGame.load_savegame() as SaveGame
		
		#gameStartTurn = _save.currentTurn
		
		party[0].displayName = _save.p1Name
		party[0].turnOrder = _save.p1TurnOrder
		print(_save.p1Conscious)
		print(_save.p1Dead)
		if !_save.p1Conscious && !_save.p1Dead:
			party[0].lifeStatus = preload("res://Assets/Database/States/Unconscious.tres")
		elif _save.p1Dead:
			party[0].lifeStatus = preload("res://Assets/Database/States/Dead.tres")
		#_save.p1Conscious = party[0].lifeStatus.canAttack
		#_save.p1Dead = party[0].lifeStatus.isDead
		
		party[0].savingRolls = _save.p1SavingRolls
		party[0].deathRolls = _save.p1DeathRolls
		party[0].hitPoints = _save.p1Health
		party[0].hitPointsMaximum = _save.p1HealthMaximum
		party[0].strength = _save.p1Strength
		party[0].dexterity = _save.p1Dexterity
		party[0].constitution = _save.p1Constitution
		party[0].intelligence = _save.p1Intelligence
		party[0].wisdom = _save.p1Wisdom
		party[0].charisma = _save.p1Charisma



		party[1].displayName = _save.p2Name
		party[1].turnOrder = _save.p2TurnOrder
		
		if !_save.p2Conscious && !_save.p2Dead:
			party[1].lifeStatus = preload("res://Assets/Database/States/Unconscious.tres")
		elif _save.p2Dead:
			party[1].lifeStatus = preload("res://Assets/Database/States/Dead.tres")
		
		party[1].savingRolls = _save.p2SavingRolls
		party[1].deathRolls = _save.p2DeathRolls
		party[1].hitPoints = _save.p2Health
		party[1].hitPointsMaximum = _save.p2HealthMaximum
		party[1].strength = _save.p2Strength
		party[1].dexterity = _save.p2Dexterity
		party[1].constitution = _save.p2Constitution
		party[1].intelligence = _save.p2Intelligence
		party[1].wisdom = _save.p2Wisdom
		party[1].charisma = _save.p2Charisma
		
		
		
		party[2].displayName = _save.p3Name
		party[2].turnOrder = _save.p3TurnOrder
		
		if !_save.p3Conscious && !_save.p3Dead:
			party[2].lifeStatus = preload("res://Assets/Database/States/Unconscious.tres")
		elif _save.p3Dead:
			party[2].lifeStatus = preload("res://Assets/Database/States/Dead.tres")
		
		party[2].savingRolls = _save.p3SavingRolls
		party[2].deathRolls = _save.p3DeathRolls
		party[2].hitPoints = _save.p3Health
		party[2].hitPointsMaximum = _save.p3HealthMaximum
		party[2].strength = _save.p3Strength
		party[2].dexterity = _save.p3Dexterity
		party[2].constitution = _save.p3Constitution
		party[2].intelligence = _save.p3Intelligence
		party[2].wisdom = _save.p3Wisdom
		party[2].charisma = _save.p3Charisma
		
		
		
		party[3].displayName = _save.p4Name
		party[3].turnOrder = _save.p4TurnOrder
		
		if !_save.p4Conscious && !_save.p4Dead:
			party[3].lifeStatus = preload("res://Assets/Database/States/Unconscious.tres")
		elif _save.p4Dead:
			party[3].lifeStatus = preload("res://Assets/Database/States/Dead.tres")
		
		party[3].savingRolls = _save.p4SavingRolls
		party[3].deathRolls = _save.p4DeathRolls
		party[3].hitPoints = _save.p4Health
		party[3].hitPointsMaximum = _save.p4HealthMaximum
		party[3].strength = _save.p4Strength
		party[3].dexterity = _save.p4Dexterity
		party[3].constitution = _save.p4Constitution
		party[3].intelligence = _save.p4Intelligence
		party[3].wisdom = _save.p4Wisdom
		party[3].charisma = _save.p4Charisma
		
		
		monsters[0].displayName = _save.mName
		monsters[0].turnOrder = _save.mTurnOrder
		monsters[0].hitPoints = _save.mHealth
		monsters[0].hitPointsMaximum = _save.mHealthMaximum
		monsters[0].strength = _save.mStrength
		monsters[0].dexterity = _save.mDexterity
		monsters[0].constitution = _save.mConstitution
		monsters[0].intelligence = _save.mIntelligence
		monsters[0].wisdom = _save.mWisdom
		monsters[0].charisma = _save.mCharisma
		
		monsters[1].displayName = _save.m2Name
		monsters[1].turnOrder = _save.m2TurnOrder		
		monsters[1].hitPoints = _save.m2Health
		monsters[1].hitPointsMaximum = _save.m2HealthMaximum
		monsters[1].strength = _save.m2Strength
		monsters[1].dexterity = _save.m2Dexterity
		monsters[1].constitution = _save.m2Constitution
		monsters[1].intelligence = _save.m2Intelligence
		monsters[1].wisdom = _save.m2Wisdom
		monsters[1].charisma = _save.m2Charisma
		
		monsters[2].displayName = _save.m3Name
		monsters[2].turnOrder = _save.m3TurnOrder		
		monsters[2].hitPoints = _save.m3Health
		monsters[2].hitPointsMaximum = _save.m3HealthMaximum
		monsters[2].strength = _save.m3Strength
		monsters[2].dexterity = _save.m3Dexterity
		monsters[2].constitution = _save.m3Constitution
		monsters[2].intelligence = _save.m3Intelligence
		monsters[2].wisdom = _save.m3Wisdom
		monsters[2].charisma = _save.m3Charisma
		
				
		party[0].get_parent().get_node("Hp").currentHealth = party[0].hitPoints
		party[0].get_parent().get_node("Hp").maxHealth = party[0].hitPointsMaximum	
			
		party[1].get_parent().get_node("Hp").currentHealth = party[1].hitPoints
		party[1].get_parent().get_node("Hp").maxHealth = party[1].hitPointsMaximum
		
		party[2].get_parent().get_node("Hp").currentHealth = party[2].hitPoints
		party[2].get_parent().get_node("Hp").maxHealth = party[2].hitPointsMaximum
		
		party[3].get_parent().get_node("Hp").currentHealth = party[3].hitPoints
		party[3].get_parent().get_node("Hp").maxHealth = party[3].hitPointsMaximum
		
		
	else: ## saves onto file
		#_save.currentCharacterList = ken.charType
		#_save.currentMonsterList = orc
		_save_files()
		

func _save_files():
		#if party[0] != null:
		
		_save.p1Name = party[0].displayName
		_save.p1TurnOrder = party[0].turnOrder
		_save.p1Conscious = party[0].lifeStatus.canAttack
		_save.p1Dead = party[0].lifeStatus.isDead
		_save.p1SavingRolls = party[0].savingRolls
		_save.p1DeathRolls = party[0].deathRolls
		_save.p1Health = party[0].hitPoints
		_save.p1HealthMaximum = party[0].hitPointsMaximum
		_save.p1Strength = party[0].strength
		_save.p1Dexterity = party[0].dexterity
		_save.p1Constitution = party[0].constitution
		_save.p1Intelligence = party[0].intelligence
		_save.p1Wisdom = party[0].wisdom
		_save.p1Charisma = party[0].charisma
		
		#if party[1] != null:
		_save.p2Name = party[1].displayName
		_save.p2TurnOrder = party[1].turnOrder
		_save.p2Conscious = party[1].lifeStatus.canAttack
		_save.p2Dead = party[1].lifeStatus.isDead
		_save.p2SavingRolls = party[1].savingRolls
		_save.p2DeathRolls = party[1].deathRolls
		_save.p2Health = party[1].hitPoints
		_save.p2HealthMaximum = party[1].hitPointsMaximum		
		_save.p2Strength = party[1].strength
		_save.p2Dexterity = party[1].dexterity
		_save.p2Constitution = party[1].constitution
		_save.p2Intelligence = party[1].intelligence
		_save.p2Wisdom = party[1].wisdom
		_save.p2Charisma = party[1].charisma
		
		#if party[2] != null:
		_save.p3Name = party[2].displayName
		_save.p3TurnOrder = party[2].turnOrder
		_save.p3Conscious = party[2].lifeStatus.canAttack
		_save.p3Dead = party[2].lifeStatus.isDead
		_save.p3SavingRolls = party[2].savingRolls
		_save.p3DeathRolls = party[2].deathRolls
		_save.p3Health = party[2].hitPoints
		_save.p3HealthMaximum = party[2].hitPointsMaximum		
		_save.p3Strength = party[2].strength
		_save.p3Dexterity = party[2].dexterity
		_save.p3Constitution = party[2].constitution
		_save.p3Intelligence = party[2].intelligence
		_save.p3Wisdom = party[2].wisdom
		_save.p3Charisma = party[2].charisma
		
		#if !party[3] == null:
		_save.p4Name = party[3].displayName
		_save.p4TurnOrder = party[3].turnOrder
		_save.p4Conscious = party[3].lifeStatus.canAttack
		_save.p4Dead = party[3].lifeStatus.isDead
		_save.p4SavingRolls = party[3].savingRolls
		_save.p4DeathRolls = party[3].deathRolls
		_save.p4Health = party[3].hitPoints
		_save.p4HealthMaximum = party[3].hitPointsMaximum		
		_save.p4Strength = party[3].strength
		_save.p4Dexterity = party[3].dexterity
		_save.p4Constitution = party[3].constitution
		_save.p4Intelligence = party[3].intelligence
		_save.p4Wisdom = party[3].wisdom
		_save.p4Charisma = party[3].charisma
		
		_save.mName = monsters[0].displayName
		_save.mTurnOrder = monsters[0].turnOrder
		_save.mHealth = monsters[0].hitPoints
		_save.mHealthMaximum = monsters[0].hitPointsMaximum		
		_save.mStrength = monsters[0].strength
		_save.mDexterity = monsters[0].dexterity
		_save.mConstitution = monsters[0].constitution
		_save.mIntelligence = monsters[0].intelligence
		_save.mWisdom = monsters[0].wisdom
		_save.mCharisma = monsters[0].charisma
		
		_save.m2Name = monsters[1].displayName
		_save.m2TurnOrder = monsters[1].turnOrder
		_save.m2Health = monsters[1].hitPoints
		_save.m2HealthMaximum = monsters[1].hitPointsMaximum		
		_save.m2Strength = monsters[1].strength
		_save.m2Dexterity = monsters[1].dexterity
		_save.m2Constitution = monsters[1].constitution
		_save.m2Intelligence = monsters[1].intelligence
		_save.m2Wisdom = monsters[1].wisdom
		_save.m2Charisma = monsters[1].charisma
		
		_save.m3Name = monsters[2].displayName
		_save.m3TurnOrder = monsters[2].turnOrder
		_save.m3Health = monsters[2].hitPoints
		_save.m3HealthMaximum = monsters[2].hitPointsMaximum		
		_save.m3Strength = monsters[2].strength
		_save.m3Dexterity = monsters[2].dexterity
		_save.m3Constitution = monsters[2].constitution
		_save.m3Intelligence = monsters[2].intelligence
		_save.m3Wisdom = monsters[2].wisdom
		_save.m3Charisma = monsters[2].charisma
		
		_save.write_savegame()
