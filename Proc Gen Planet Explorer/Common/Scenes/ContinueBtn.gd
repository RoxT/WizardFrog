extends Button


export(String, FILE) var next_scene


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	show()


func _on_ContinueBtn_pressed():
	var err := get_tree().change_scene(next_scene)
	if err != OK:
		push_error("Error changing scene: " + str(err))
