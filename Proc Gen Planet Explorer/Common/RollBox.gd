extends Panel

export(Array, String) var actions setget set_actions
onready var label_list := $ActionList.get_children()
var result:int = -1
var ready := false

signal rolled(action)

# Called when the node enters the scene tree for the first time.
func _ready():
	ready = true
	if actions.size() == 6:
		for i in range(6):
			label_list[i].text = actions[i]


func set_actions(value:Array):
	if not ready:
		return
	$Roll.disabled = (value.size() == 0)
	if value.size() == 0:
		return
	assert(value.size() == 6)
	if result > -1: label_list[result].remove_stylebox_override("normal")
	actions = value
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
