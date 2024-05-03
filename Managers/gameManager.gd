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
var mm:MonsterManual = MonsterManual.new()
var monstersAttacking = []


func _ready():
	mm.parse_monster_file("res://Model/MonsterManual.txt")
	var ken = Character.new("Ken", "Paladin", preload("res://Assets/Database/Items/Weapons/Longsword.tres") ,preload("res://Assets/Database/Items/Armor/StuddedLeather.tres"))
	var barby = Character.new("Barby", "Warrior", preload("res://Assets/Database/Items/Weapons/Greataxe.tres"), preload("res://Assets/Database/Items/Armor/StuddedLeather.tres"))
	var roland = Character.new("Roland", "Assassin", preload("res://Assets/Database/Items/Weapons/LightCrossbow.tres"), preload("res://Assets/Database/Items/Armor/StuddedLeather.tres"))
	var melissa = Character.new("Melissa", "Wizard", preload("res://Assets/Database/Items/Weapons/Longsword.tres"), preload("res://Assets/Database/Items/Armor/StuddedLeather.tres"))
			
	party_slot_0.add_child(ken)	
	party_slot_1.add_child(barby)
	party_slot_2.add_child(roland)
	party_slot_3.add_child(melissa)
	
	var party = Party.new([ken, barby, roland, melissa])
	#var orc = Monster.new("Orc", dice.roll("2d8+6"), 10)
	#var troll = Monster.new("Troll", dice.roll("4d10+120"), 15)
	#var mm = Monster.new(mm.monsters[73].name, dice.roll(mm.monsters[73].hit_points_roll), mm.monsters[73].armor_class)
	var monsters = []
	var orc1type:MonsterType = load("res://Assets/Database/Monster/Orc1.tres")
	var orc2type:MonsterType = load("res://Assets/Database/Monster/Orc2.tres")
	var orc3type:MonsterType = load("res://Assets/Database/Monster/Orc3.tres")
	var youngRedDragon:MonsterType = load("res://Assets/Database/Monster/YoungRedDragon.tres")
	
	monsters.append(Monster.new(orc1type))
	monsters.append(Monster.new(youngRedDragon))
	#monsters.append(Monster.new(orc2type))
	#monsters.append(Monster.new(orc3type))
	
	console.clear()	
	var gs = newGame(party, monsters)
	Simulate(gs)

func newGame(party: Party, monsters: Array) -> GameState:
	return GameState.new(party, monsters)
	
func Simulate(game: GameState):
	cm.SimulateBattle(game)
	
