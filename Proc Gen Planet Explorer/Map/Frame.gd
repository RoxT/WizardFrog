extends ReferenceRect


onready var label := $Label
onready var tween := $Tween

export(int) var cost setget set_cost


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
#	tween.interpolate_property(self, "rect_position",
#		rect_position, new_pos, 0.1,
#		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	tween.start()
	rect_position = new_pos

