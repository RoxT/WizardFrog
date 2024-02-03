extends CanvasLayer


onready var rollbox := $RollBox
onready var talk := $Talk
onready var next := $Next

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func just_go():
	rollbox.set_as_go()
	
func reset():
	$Talk.text = ""
	next.destroy_options()
