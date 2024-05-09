extends Node

@onready var console = $Console
@onready var dice = $Dice
#@onready var cm = CombatManager.new(console)
@onready var cm: Node2D = $Node2D
@onready var party_slot_0: Sprite2D = $Node2D/PartySlot0
@onready var party_slot_1: Sprite2D = $Node2D/PartySlot1
@onready var party_slot_2: Sprite2D = $Node2D/PartySlot2
@onready var party_slot_3: Sprite2D = $Node2D/PartySlot3
@onready var monster_slot: Sprite2D = $Node2D/MonsterSlot
#@onready var party: Party
@onready var party = []
@onready var monsters = []
@onready var orc
@onready var azer
@onready var youngRedDragon
@onready var ken
@onready var barby
@onready var roland
@onready var melissa
#var mm:MonsterManual = MonsterManual.new()
#var monstersAttacking = []
var _save = SaveGame.new()

func _ready():
	#mm.parse_monster_file("res://Model/MonsterManual.txt")
	#if _save.save_exists():
	#	_create_or_load_save()
	#else:	
	ken = Character.new("Ken", preload("res://Assets/Database/Heroes/Paladin.tres"))
	barby = Character.new("Barby", preload("res://Assets/Database/Heroes/Warrior.tres"))
	roland = Character.new("Roland", preload("res://Assets/Database/Heroes/Assassin.tres"))
	melissa = Character.new("Melissa", preload("res://Assets/Database/Heroes/Mage.tres"))
	party_slot_0.add_child(ken)
	party_slot_1.add_child(barby)
	party_slot_2.add_child(roland)
	party_slot_3.add_child(melissa)
	party.append(ken)
	party.append(barby)
	party.append(roland)
	party.append(melissa)
	
	orc = load("res://Assets/Database/Monster/Orc.tres")
	azer = load("res://Assets/Database/Monster/Azer.tres")
	youngRedDragon = load("res://Assets/Database/Monster/YoungRedDragon.tres")
	monsters.append(Monster.new(orc))
	monsters.append(Monster.new(azer))
	monsters.append(Monster.new(youngRedDragon))
	
					
	
	#_create_or_load_save()
	console.clear()	
	var gs = newGame(party, monsters)
	Simulate(gs)

func newGame(party: Array, monsters: Array) -> GameState:
	return GameState.new(party, monsters)
	
func Simulate(game: GameState):
	cm.SimulateBattle(game)
	
	
#func _create_or_load_save() -> void:
	#if SaveGame.save_exists(): ## loads from file
		#_save = SaveGame.load_savegame() as SaveGame
		#
		#ken = Character.new("Ken", preload("res://Assets/Database/Heroes/Paladin.tres"))
		#barby = Character.new("Barby", preload("res://Assets/Database/Heroes/Warrior.tres"))
		#roland = Character.new("Roland", preload("res://Assets/Database/Heroes/Assassin.tres"))
		#melissa = Character.new("Melissa", preload("res://Assets/Database/Heroes/Mage.tres"))
		#
		#
		#orc = load("res://Assets/Database/Monster/Orc.tres")
		#azer = load("res://Assets/Database/Monster/Azer.tres")
		#youngRedDragon = load("res://Assets/Database/Monster/YoungRedDragon.tres")
		#
		#monsters.append(Monster.new(orc))
		#monsters.append(Monster.new(azer))
		#monsters.append(Monster.new(youngRedDragon))
		#
		#party_slot_0.add_child(ken)
		#party_slot_1.add_child(barby)
		#party_slot_2.add_child(roland)
		#party_slot_3.add_child(melissa)
		#party.append(ken)
		#party.append(barby)
		#party.append(roland)
		#party.append(melissa)
		##party = Party.new([ken, barby, roland, melissa])
		#
		#party[0].displayName = _save.p1Name
		#party[0].hitPoints = _save.p1Health
		#party[0].hitPointsMaximum = _save.p1HealthMaximum
		#party[0].strength = _save.p1Strength
		#party[0].dexterity = _save.p1Dexterity
		#party[0].constitution = _save.p1Constitution
		#party[0].intelligence = _save.p1Intelligence
		#party[0].wisdom = _save.p1Wisdom
		#party[0].charisma = _save.p1Charisma
#
		#party[1].displayName = _save.p2Name
		#party[1].hitPoints = _save.p2Health
		#party[1].hitPointsMaximum = _save.p2HealthMaximum
		#party[1].strength = _save.p2Strength
		#party[1].dexterity = _save.p2Dexterity
		#party[1].constitution = _save.p2Constitution
		#party[1].intelligence = _save.p2Intelligence
		#party[1].wisdom = _save.p2Wisdom
		#party[1].charisma = _save.p2Charisma
		#
		#party[2].displayName = _save.p3Name
		#party[2].hitPoints = _save.p3Health
		#party[2].hitPointsMaximum = _save.p3HealthMaximum
		#party[2].strength = _save.p3Strength
		#party[2].dexterity = _save.p3Dexterity
		#party[2].constitution = _save.p3Constitution
		#party[2].intelligence = _save.p3Intelligence
		#party[2].wisdom = _save.p3Wisdom
		#party[2].charisma = _save.p3Charisma
		#
		#party[3].displayName = _save.p4Name
		#party[3].hitPoints = _save.p4Health
		#party[3].hitPointsMaximum = _save.p4HealthMaximum
		#party[3].strength = _save.p4Strength
		#party[3].dexterity = _save.p4Dexterity
		#party[3].constitution = _save.p4Constitution
		#party[3].intelligence = _save.p4Intelligence
		#party[3].wisdom = _save.p4Wisdom
		#party[3].charisma = _save.p4Charisma
		#
		#
		#monsters[0].displayName = _save.mName
		#monsters[0].hitPoints = _save.mHealth
		#monsters[0].hitPointsMaximum = _save.mHealthMaximum
		#monsters[0].strength = _save.mStrength
		#monsters[0].dexterity = _save.mDexterity
		#monsters[0].constitution = _save.mConstitution
		#monsters[0].intelligence = _save.mIntelligence
		#monsters[0].wisdom = _save.mWisdom
		#monsters[0].charisma = _save.mCharisma
		#
		#monsters[1].displayName = _save.m2Name
		#monsters[1].hitPoints = _save.m2Health
		#monsters[1].hitPointsMaximum = _save.m2HealthMaximum
		#monsters[1].strength = _save.m2Strength
		#monsters[1].dexterity = _save.m2Dexterity
		#monsters[1].constitution = _save.m2Constitution
		#monsters[1].intelligence = _save.m2Intelligence
		#monsters[1].wisdom = _save.m2Wisdom
		#monsters[1].charisma = _save.m2Charisma
		#
		#monsters[2].displayName = _save.m3Name
		#monsters[2].hitPoints = _save.m3Health
		#monsters[2].hitPointsMaximum = _save.m3HealthMaximum
		#monsters[2].strength = _save.m3Strength
		#monsters[2].dexterity = _save.m3Dexterity
		#monsters[2].constitution = _save.m3Constitution
		#monsters[2].intelligence = _save.m3Intelligence
		#monsters[2].wisdom = _save.m3Wisdom
		#monsters[2].charisma = _save.m3Charisma
		#
		#party_slot_0.get_node("Hp").currentHealth = party[0].hitPoints
		#party_slot_0.get_node("Hp").maxHealth = party[0].hitPointsMaximum	
			#
		#party_slot_1.get_node("Hp").currentHealth = party[1].hitPoints
		#party_slot_1.get_node("Hp").maxHealth = party[1].hitPointsMaximum
		#
		#party_slot_2.get_node("Hp").currentHealth = party[2].hitPoints
		#party_slot_2.get_node("Hp").maxHealth = party[2].hitPointsMaximum
		#
		#party_slot_3.get_node("Hp").currentHealth = party[3].hitPoints
		#party_slot_3.get_node("Hp").maxHealth = party[3].hitPointsMaximum
		#
				#
		#console.clear()	
		#var gs = newGame(party, monsters)
		#Simulate(gs)
		#
	#else: ## saves onto file
		##_save.currentCharacterList = ken.charType
		##_save.currentMonsterList = orc
		#
		#_save.p1Name = party[0].displayName
		#_save.p1Health = party[0].hitPoints
		#_save.p1HealthMaximum = party[0].hitPointsMaximum
		#_save.p1Strength = party[0].strength
		#_save.p1Dexterity = party[0].dexterity
		#_save.p1Constitution = party[0].constitution
		#_save.p1Intelligence = party[0].intelligence
		#_save.p1Wisdom = party[0].wisdom
		#_save.p1Charisma = party[0].charisma
		#
		#_save.p2Name = party[1].displayName
		#_save.p2Health = party[1].hitPoints
		#_save.p2HealthMaximum = party[1].hitPointsMaximum		
		#_save.p2Strength = party[1].strength
		#_save.p2Dexterity = party[1].dexterity
		#_save.p2Constitution = party[1].constitution
		#_save.p2Intelligence = party[1].intelligence
		#_save.p2Wisdom = party[1].wisdom
		#_save.p2Charisma = party[1].charisma
		#
		#_save.p3Name = party[2].displayName
		#_save.p3Health = party[2].hitPoints
		#_save.p3HealthMaximum = party[2].hitPointsMaximum		
		#_save.p3Strength = party[2].strength
		#_save.p3Dexterity = party[2].dexterity
		#_save.p3Constitution = party[2].constitution
		#_save.p3Intelligence = party[2].intelligence
		#_save.p3Wisdom = party[2].wisdom
		#_save.p3Charisma = party[2].charisma
		#
		#_save.p4Name = party[3].displayName
		#_save.p4Health = party[3].hitPoints
		#_save.p4HealthMaximum = party[3].hitPointsMaximum		
		#_save.p4Strength = party[3].strength
		#_save.p4Dexterity = party[3].dexterity
		#_save.p4Constitution = party[3].constitution
		#_save.p4Intelligence = party[3].intelligence
		#_save.p4Wisdom = party[3].wisdom
		#_save.p4Charisma = party[3].charisma
		#
		#_save.mName = monsters[0].displayName
		#_save.mHealth = monsters[0].hitPoints
		#_save.mHealthMaximum = monsters[0].hitPointsMaximum		
		#_save.mStrength = monsters[0].strength
		#_save.mDexterity = monsters[0].dexterity
		#_save.mConstitution = monsters[0].constitution
		#_save.mIntelligence = monsters[0].intelligence
		#_save.mWisdom = monsters[0].wisdom
		#_save.mCharisma = monsters[0].charisma
		#
		#_save.m2Name = monsters[1].displayName
		#_save.m2Health = monsters[1].hitPoints
		#_save.m2HealthMaximum = monsters[1].hitPointsMaximum		
		#_save.m2Strength = monsters[1].strength
		#_save.m2Dexterity = monsters[1].dexterity
		#_save.m2Constitution = monsters[1].constitution
		#_save.m2Intelligence = monsters[1].intelligence
		#_save.m2Wisdom = monsters[1].wisdom
		#_save.m2Charisma = monsters[1].charisma
		#
		#_save.m3Name = monsters[2].displayName
		#_save.m3Health = monsters[2].hitPoints
		#_save.m3HealthMaximum = monsters[2].hitPointsMaximum		
		#_save.m3Strength = monsters[2].strength
		#_save.m3Dexterity = monsters[2].dexterity
		#_save.m3Constitution = monsters[2].constitution
		#_save.m3Intelligence = monsters[2].intelligence
		#_save.m3Wisdom = monsters[2].wisdom
		#_save.m3Charisma = monsters[2].charisma
		#
		#_save.write_savegame()
