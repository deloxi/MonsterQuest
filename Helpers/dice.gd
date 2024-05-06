extends Node

class_name Dice

#@export var dice_count: int = 1
var dice_count: int
var dice_sides: int
var modifier: int
var rolls: Array = []
#@export var dice_sides: int = 6
#@export var modifier: int = 0
#@export var rolls: Array = []

var _random = RandomNumberGenerator.new()

#utils
func split(s: String, delimeters, allow_empty: bool = true) -> Array:
	var parts := []
	
	var start := 0
	var i := 0
	
	while i < s.length():
		if s[i] in delimeters:
			if allow_empty or start < i:
				parts.push_back(s.substr(start, i - start))
			start = i + 1
		i += 1
	
	if allow_empty or start < i:
		parts.push_back(s.substr(start, i - start))
	
	return parts

#Constructor
func _init(dice_string: String = "1d6"):
	parse_dice_string(dice_string)

func parse_dice_string(dice_string:String):
	var parts = split(dice_string, ["+","-"])
	var has_modifier = dice_string.contains("+") or dice_string.contains("-")
	
	if has_modifier:
		var mod = int(parts[parts.size()-1])
		modifier = mod*(-1 if dice_string.contains("-") else 1)
	else:
		modifier = 0
		
	var dice_parts = parts[0].split("d")
	if dice_parts.size() == 2 and dice_parts[0] != "":
		dice_count = int(dice_parts[0])
	else:
		dice_count = 1
		
	dice_sides = int(dice_parts[-1])
	
func roll(diceString: String) -> int:
	parse_dice_string(diceString)
	rolls.clear()
	var total = 0
	for i in range(dice_count):
		var roll = _random.randi_range(1, dice_sides)
		rolls.append(roll)
		total += roll
	return total+modifier


static func rollWithDice(diceAmount, diceSides, modifier):
	randomize()
	var roll = 0
	var total = 0
	
	for dice in diceAmount:
		roll = randi_range(1,diceSides)
		total += roll
	
	total += modifier
	return total




