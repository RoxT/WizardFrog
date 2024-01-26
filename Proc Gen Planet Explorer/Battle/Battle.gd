extends CanvasLayer

onready var roll_box := $RollBox
onready var history := $History
onready var talk := $Talk
onready var wizard := $Portrait
onready var next_list : = $Next
const PATH := "res://%s"

var foe:Scene

# Called when the node enters the scene tree for the first time.
func _ready():
	for n in next_list.get_children(): n.queue_free()
	if foe == null: foe = load("res://DictTest/Scenes/Snake.tres") as Scene
	var err := roll_box.connect("rolled", self, "on_rolled")
	if err != OK: push_error("Error connecting " + str(err))
	
	talk.text = foe.hello
	wizard.texture = foe.load_texture()
	$Portrait/HP.text = "HP: " + str(foe.hp)
	$RollBox.actions = foe.intro

func on_rolled(response:String):
	destroy_options()
	var next = foe.scenes[response]
	if !(next is Dictionary):
		next = foe.scenes[next as String]
	talk.text = next.talk
	var options = next.options
	for o in options:
		var btn = preload("res://Battle/ChoiceButton.tscn").instance() as Button
		btn.text = o
		var err = btn.connect("pressed", self, "_on_Next_pressed", [o])
		if err != OK: push_error("Error connecting " + str(err))
		next_list.add_child(btn)

func destroy_options():
	for b in next_list.get_children():
		b = b as Button
		b.disconnect("pressed", self, "_on_Next_pressed")
		b.queue_free()

func _on_Next_pressed(option:String):
	match option:
		"Fight!": pass
		"Leave": 
			queue_free()
		var scene:
			on_rolled(scene)
