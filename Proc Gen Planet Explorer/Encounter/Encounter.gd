extends CanvasLayer

onready var history := $History
onready var wizard := $Portrait
onready var audio_player := $AudioStreamPlayer
const PATH := "res://%s"

var hud
var foe:Scene

# Called when the node enters the scene tree for the first time.
func _ready():
	if hud == null:
		hud = load("res://Common/HUD.tscn").instance()
		add_child(hud)
	$Panel.modulate.a = 0.7
	if foe == null: foe = load("res://Data/Scenes/Wizard.tres") as Scene
	var err = hud.rollbox.connect("rolled", self, "on_rolled")
	if err != OK: push_error("Error connecting " + str(err))
	
	hud.talk.text = foe.hello
	wizard.texture = foe.load_texture()
	$Portrait/HP.text = "HP: " + str(foe.hp)
	hud.rollbox.actions = foe.intro
	
	var sound = foe.load_sound_or_null()
	if sound != null:
		audio_player.stream = sound
		audio_player.play()

func on_rolled(response:String):
	$Panel.modulate.a = 1
	var next_scene = foe.scenes[response]
	if !(next_scene is Dictionary):
		next_scene = foe.scenes[next_scene as String]
	hud.talk.text = next_scene.talk
	hud.next.connect_options(self, next_scene.options)

func _on_Next_pressed(option:String):
	match option:
		"Fight!": pass
		"Leave": 
			hud.talk.text = ""
			hud.next.destroy_options(self)
			queue_free()
		var scene:
			on_rolled(scene)
