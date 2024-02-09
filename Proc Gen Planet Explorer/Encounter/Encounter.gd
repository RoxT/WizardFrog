extends CanvasLayer

onready var portrait := $Portrait
onready var audio_player := $AudioStreamPlayer
const PATH := "res://%s"
export(Resource) var foe_override

var hud
var foe:Scene
var mob:Mob
var tile:Control
var fighting = false #Connect to other variable?
var turns := []


# Called when the node enters the scene tree for the first time.
func _ready():
	if hud == null: #Debug Mode
		hud = load("res://Common/Scenes/HUD.tscn").instance()
		add_child(hud)
		hud.connect_me(self)
		mob = Mob.new(foe_override) as Mob
	else:
		mob = tile.mob
	foe = mob.scene
	hud.reset()
	$Panel.modulate.a = 0.7
	
	hud.talk.text = foe.hello
	portrait.texture = foe.load_texture()
	draw_hp()
	hud.rollbox.actions = foe.intro.roll
	if "options" in foe.intro:
		hud.next.connect_options(self, foe.intro.options)
	
	var sound = foe.load_sound_or_null()
	if sound != null:
		audio_player.stream = sound
		audio_player.play()

func draw_hp():
	if mob.max_hp > 0:
		$Portrait/HP.text = "Health: " + str(mob.hp)
	else:
		$Portrait/HP.hide()
		
#Passed from Map
func _on_rolled(roll:String):
	$Panel.modulate.a = 1
	if fighting:
		mob.hp -= int(roll)
		draw_hp()
		if mob.hp > 0:
			hud.talk.text = "You hit for " + roll + "! Roll to hit again."
		else:
			hud.talk.text = "You hit for " + roll + " and destroyed the beast!"
			hud.next.connect_options(self, ["Leave"])
			hud.no_roll()
			if tile: tile.mob = null # Remove from save???
	else:
		var next_scene = foe.scenes[roll]
		if !(next_scene is Dictionary):
			next_scene = foe.scenes[next_scene as String]
		hud.talk.text = next_scene.talk
		hud.next.connect_options(self, next_scene.options)

#Passed from Map
func _on_Next_pressed(option:String):
	match option:
		"Fight!": 
			fighting = true
			var player := hud.player_leaf.player as Player
			if tile: tile.hostile = true
			hud.talk.text = "Roll to swing your " + player.weapon.title + "."
			hud.rollbox.actions = player.weapon.rolls
			hud.next.connect_options(self, ["Flee"])
		"Drink":
			hud.player_leaf.player.heal_ability()
			#Character flashes?
			leave()
		"Leave": 
			leave()
		"Flee":
			leave()
		var scene:
			_on_rolled(scene)

func leave():
	hud.rollbox.empty_actions()
	hud.talk.text = ""
	hud.next.destroy_options()
	queue_free()
	
