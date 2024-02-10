extends CanvasLayer

onready var portrait := $Portrait
onready var audio_player := $AudioStreamPlayer
const PATH := "res://%s"
export(Resource) var scene_override

var hud
var scene:Scene
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
		mob = Mob.new(scene_override) as Mob
	else:
		mob = tile.mob
	scene = mob.scene
	hud.reset()
	$Panel.modulate.a = 0.7
	
	hud.talk.text = scene.hello
	portrait.texture = scene.load_texture()
	draw_hp()
	hud.rollbox.actions = scene.intro.roll
	if "options" in scene.intro:
		hud.next.connect_options(self, scene.intro.options)
	
	var sound = scene.load_sound_or_null()
	if sound != null:
		audio_player.stream = sound
		audio_player.play()

func draw_hp():
	if mob.has_combat():
		$Portrait/HP.text = "Health: " + str(mob.combat.hp)
	else:
		$Portrait/HP.hide()
		
#Passed from Map
func _on_rolled(roll:String):
	$Panel.modulate.a = 1
	if fighting:
		mob.combat.hp -= int(roll)
		draw_hp()
		if mob.combat.hp > 0:
			hud.talk.text = "You hit for " + roll + "! Roll to hit again."
		else:
			hud.talk.text = "You hit for " + roll + " and destroyed the beast!"
			hud.next.connect_options(self, ["Leave"])
			hud.no_roll()
			if tile: tile.mob = null # Remove from save???
	else:
		var next_scene = scene.scenes[roll]
		if !(next_scene is Dictionary):
			next_scene = scene.scenes[next_scene as String]
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
			hud.rollbox.actions = player.combat.dmg
			hud.next.connect_options(self, ["Flee"])
		"Drink":
			hud.player_leaf.player.combat.heal_ability()
			#Character flashes?
			leave()
		"Leave":
			if tile: tile.hostile = false
			leave()
		"Flee":
			leave()
		var next_scene:
			_on_rolled(next_scene)

func leave():
	hud.rollbox.empty_actions()
	hud.talk.text = ""
	hud.next.destroy_options()
	queue_free()
	
