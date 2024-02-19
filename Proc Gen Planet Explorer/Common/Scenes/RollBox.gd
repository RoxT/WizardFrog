extends Panel

export(Array, String) var actions setget set_actions
const NEW_STYLEBOX:StyleBoxFlat = preload("res://Common/Scenes/new_styleboxflat.tres")
onready var label_list := $ActionList.get_children()
onready var animation_player := $AnimationPlayer
onready var breath := $Breath
var result:int = -1
var ready := false

signal rolled(action)

# Called when the node enters the scene tree for the first time.
func _ready():
	ready = true
	if actions.size() == 6:
		for i in range(6):
			label_list[i].text = actions[i]

func set_no_roll():
	$Roll.disabled = true

func empty_actions():
	for l in label_list:
		l.text = ""
		un_highlight(l)

func set_as_go():
	empty_actions()
	$Roll.text = "Go"
	$Roll.disabled = false

func no_roll():
	$Roll.disabled = true

func set_actions(value:Array):
	if not ready:
		return
	$Roll.text = "Roll"
	$Roll.disabled = (value.size() == 0)
	if value.size() == 0:
		return
	assert(value.size() == 6)
	if result > -1: un_highlight(label_list[result])
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
			var other: t = str(other)
		label_list[i].text = t
	

func _on_Roll_pressed():
	animation_player.play("roll")
	set_no_roll()

func _on_AnimationPlayer_animation_finished(_anim_name):
	result = randi() % 6
	highlight(label_list[result])
	_on_Breath_timeout()
	
func _on_Breath_timeout():
	emit_signal("rolled", str(actions[result]))

func highlight(label:Label):
	label.add_stylebox_override("normal", NEW_STYLEBOX)

func un_highlight(label:Label):
	label.remove_stylebox_override("normal")

