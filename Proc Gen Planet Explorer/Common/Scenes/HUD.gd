extends CanvasLayer


onready var rollbox := $RollBox
onready var talk := $Talk
onready var next := $Next
onready var player_leaf := $CharacterLeaf

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func just_go():
	rollbox.set_as_go()

func no_roll():
	rollbox.no_roll()
	
func reset():
	$Talk.text = ""
	next.destroy_options()

func connect_me(target:Node):
	var err = rollbox.connect("rolled", target, "_on_rolled")
	if err != OK: push_error("Error connecting HUD to " + target.name)
	
