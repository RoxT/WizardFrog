extends Panel

export(Array, String) var actions setget set_actions
onready var label_list := $ActionList.get_children()
onready var animation_player := $AnimationPlayer
var result:int = -1
var ready := false

signal rolled(action)

# Called when the node enters the scene tree for the first time.
func _ready():
	ready = true
	for l in label_list:
		var err = l.connect("highlight_finished", self, "_on_animate_highlight_finished")
		if err != OK: push_warning("Error connecting " + str(err))
	if actions.size() == 6:
		for i in range(6):
			label_list[i].text = actions[i]

func set_no_roll():
	$Roll.disabled = true

func empty_actions():
	for l in label_list:
		l.text = ""
		l.un_highlight()

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
	if result > -1: label_list[result].un_highlight()
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
	

#Roll -> Animate Roll -> Animate Highlight
func _on_Roll_pressed():
	animation_player.play("roll")
#	set_no_roll()

func _on_AnimationPlayer_animation_finished(_anim_name):
	result = randi() % 6
	label_list[result].animate_highlight()
	
func _on_animate_highlight_finished():
	emit_signal("rolled", str(actions[result]))

