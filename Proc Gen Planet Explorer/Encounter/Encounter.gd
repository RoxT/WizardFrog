extends CanvasLayer

onready var portrait := $Portrait
onready var audio_player := $AudioStreamPlayer
const PATH := "res://%s"
export(Resource) var foe_override

var hud
var foe:Scene
var tile

# Called when the node enters the scene tree for the first time.
func _ready():
	if hud == null:
		hud = load("res://Common/Scenes/HUD.tscn").instance()
		add_child(hud)
	if foe == null: foe = foe_override as Scene
	hud.reset()
	$Panel.modulate.a = 0.7
	var err = hud.rollbox.connect("rolled", self, "on_rolled")
	if err != OK: push_error("Error connecting " + str(err))
	
	hud.talk.text = foe.hello
	portrait.texture = foe.load_texture()
	$Portrait/HP.text = "HP: " + str(foe.hp)
	hud.rollbox.actions = foe.intro.roll
	if "options" in foe.intro:
		hud.next.connect_options(self, foe.intro.options)
	
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
		"Fight!": 
			if tile: tile.hostile = true
			leave()
		"Drink":
			#Characters recover
			#Character flashes?
			leave()
		"Leave": 
			leave()
		var scene:
			on_rolled(scene)

func leave():
	hud.rollbox.empty_actions()
	hud.talk.text = ""
	hud.next.destroy_options()
	queue_free()
	
