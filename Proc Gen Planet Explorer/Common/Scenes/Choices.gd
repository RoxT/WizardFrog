extends VFlowContainer


const BUTTON := preload("res://Encounter/ChoiceButton.tscn")
const EMPTY_BTN := preload("res://Common/Scenes/EmptyBtn.tscn")
var last_target
const FLEE_ONLY := ["","","","Flee"]
const NEXT_FLEE := ["Next","","","Flee"]

# Called when the node enters the scene tree for the first time.
func _ready():
	for b in get_children(): b.queue_free()

func connect_options(target:Node, options:Array):
	destroy_options()
	last_target = target
	for o in options:
		var btn:Button
		if str(o).empty():
			btn = EMPTY_BTN.instance()
		else:
			btn = BUTTON.instance()
			btn.text = str(o)
			var err = btn.connect("pressed", target, "_on_Next_pressed", [o])
			if err != OK: push_error("Error connecting " + str(err))
		add_child(btn)

func destroy_options():
	for b in get_children():
		b = b as Button
		if last_target and b.is_connected("pressed", last_target, "_on_Next_pressed"):
			b.disconnect("pressed", last_target, "_on_Next_pressed")
		b.queue_free()
