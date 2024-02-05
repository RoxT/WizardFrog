class_name ARoll
extends Resource
export(Array) var options = []
#Actions
const FIGHT := "Fight!"
const LEAVE := "Leave"
const DRINK := "Drink"
#export(Resource) var sub_resource
#export(Array, String) var strings

func _init(new_options = []):
	options = new_options


static func match_temperment(value:String)->String:
	match value:
		"H": return "Helpful"
		"C": return "Curious"
		"I": return "Indifferent"
		"W": return "Wary"
		"R": return "Rude"
		"O": return "Hostile" #Ornery
	push_warning("Not a temperment: " + value)
	return "Unknown Tempertment"
