extends VFlowContainer


const BUTTON := preload("res://Encounter/ChoiceButton.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	for b in get_children(): b.queue_free()

func connect_options(target:Node, options:Array):
	destroy_options(target)
	for o in options:
		var btn = BUTTON.instance() as Button
		btn.text = o
		var err = btn.connect("pressed", target, "_on_Next_pressed", [o])
		if err != OK: push_error("Error connecting " + str(err))
		add_child(btn)

func destroy_options(target:Node):
	for b in get_children():
		b = b as Button
		if target:
			b.disconnect("pressed", target, "_on_Next_pressed")
		b.queue_free()
