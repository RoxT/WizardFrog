extends ReferenceRect


onready var label := $Label
onready var tween := $Tween
onready var animation_player := $AnimationPlayer

const TIME := 0.1

export(int) var cost setget set_cost

signal frame_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = str(cost)


func set_cost(value:int):
	cost = value
	if label.is_inside_tree():
		label.text = str(cost)
		label.show()

func move(new_pos:Vector2, new_cost:=-1):
	show()
	cost = new_cost
	if cost < 0:
		label.hide()
	else:
		label.text = str(cost)
		label.show()
	tween.interpolate_property(self, "rect_position",
		rect_position, new_pos, TIME,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	tween.interpolate_property(self, "modulate",
#		Color(1,1,1,0), Color.white, TIME,
#		Tween.TRANS_LINEAR, Tween.EASE_IN)
	animation_player.play("fade_in")
	tween.start()



func _on_Frame_gui_input(event:InputEvent):
	if event is InputEventMouseButton:
		if event.pressed:
			emit_signal("frame_pressed")
