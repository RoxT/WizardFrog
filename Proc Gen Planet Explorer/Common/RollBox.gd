extends Panel

export(Array, String) var actions setget set_actions
onready var label_list := $ActionList.get_children()
var result:int
var ready := false

signal rolled(action)

# Called when the node enters the scene tree for the first time.
func _ready():
	ready = true
	if actions.size() == 6:
		for i in range(6):
			label_list[i].text = actions[i]

func set_actions(value:Array):
	assert(value.size() == 6)
	actions = value
	if not ready:
		return
	for i in range(6):
		var t:String
		match actions[i]:
			"H": t = "Helpful"
			"C": t = "Curious"
			"I": t = "Indifferent"
			"W": t = "Wary"
			"R": t = "Rude"
			"O": t = "Hostile"
			var other: t = other
		label_list[i].text = t
	

func _on_Roll_pressed():
	result = randi() % 6
	for label in label_list:
		label.remove_stylebox_override("normal")
	label_list[result].add_stylebox_override("normal", StyleBoxFlat.new())
	emit_signal("rolled", actions[result])
