class_name MonsterManual extends Resource

@export var name : String
@export var description : String
@export var alignment : String 
@export var hit_points_default : int
@export var hit_points_roll : String  
@export var armor_class : int
@export var armor_type : String
@export var speeds : Dictionary 
@export var challenge_rating : float  
@export var xp : int

var monsters: Array

func _init():
	monsters = []
	pass

func get_regex_match_string(line: String, pattern: String, group_index: int = 1) -> String:
	var regex = RegEx.new()
	regex.compile(pattern)
	var match = regex.search(line)
	return match.get_string(group_index) if match else ""

func parse_monster_file(file_path: String) -> void:
	var file = FileAccess.open(file_path, FileAccess.READ)
	var content = file.get_as_text(true)
	var monster_blocks = content.split("\n\n")
	for block in monster_blocks:
		var monster = MonsterManual.new()
		var lines = block.split("\n")
		
		#name
		monster.name = lines[0].strip_edges()
		#desc, alignment
		var desc_align_regex = RegEx.new()
		desc_align_regex.compile("^(?<description>.+?),\\s*(?<alignment>[^,]+)$")
		var desc_align_match = desc_align_regex.search(lines[1]) 
		if desc_align_match != null:
			monster.description = desc_align_match.get_string("description")
			monster.alignment = desc_align_match.get_string("alignment")
		#hp
		monster.hit_points_default = get_regex_match_string(lines[2], "(\\d+)")
		monster.hit_points_roll = get_regex_match_string(lines[2], "\\((.*?)\\)")
		
		monster.armor_class = get_regex_match_string(lines[3], "(\\d+)")
		monster.armor_type = get_regex_match_string(lines[3], "\\((.*?)\\)")
		
		monsters.append(monster)
		
	file.close()
