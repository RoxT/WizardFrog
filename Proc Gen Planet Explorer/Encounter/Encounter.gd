extends CanvasLayer

onready var roll_box := $RollBox
onready var history := $History
onready var talk := $Talk
onready var wizard := $Portrait
onready var audio_player := $AudioStreamPlayer
onready var choices := $Next
const PATH := "res://%s"

var foe:Scene

# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel.modulate.a = 0.5
	if foe == null: foe = load("res://Data/Scenes/Wizard.tres") as Scene
	var err := roll_box.connect("rolled", self, "on_rolled")
	if err != OK: push_error("Error connecting " + str(err))
	
	talk.text = foe.hello
	wizard.texture = foe.load_texture()
	$Portrait/HP.text = "HP: " + str(foe.hp)
	$RollBox.actions = foe.intro
	
	var sound = foe.load_sound_or_null()
	if sound != null:
		audio_player.stream = sound
		audio_player.play()

func on_rolled(response:String):
	$Panel.modulate.a = 1
	var next = foe.scenes[response]
	if !(next is Dictionary):
		next = foe.scenes[next as String]
	talk.text = next.talk
	choices.connect_options(self, next.options)

func _on_Next_pressed(option:String):
	match option:
		"Fight!": pass
		"Leave": 
			queue_free()
		var scene:
			on_rolled(scene)
