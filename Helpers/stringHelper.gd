class_name stringHelper


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


static func joinWithAnd(names):
	var count = names.size()
	
	if count == 0:
		return ""
	elif count == 1:
		return names[0].displayName
	elif count == 2:
		return names[0].displayName + " and " + names[1].displayName
	else:
		var namesCopy = ""
		for name in names:
			namesCopy += name.displayName + ", "
			if name.displayName == names[-3].displayName:
				break
		namesCopy += names[-2].displayName + " and " + names[-1].displayName
		return namesCopy
