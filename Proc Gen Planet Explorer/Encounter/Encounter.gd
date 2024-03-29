extends CanvasLayer

const TURN_MANAGER := preload("res://Encounter/Combat/TurnManager.tscn")

onready var portrait := $Portrait
onready var audio_player := $AudioStreamPlayer
const PATH := "res://%s"
export(Resource) var scene_override

var hud
var scene:Scene
var mob:Encounterable
var tile:Tile
var mob_target
var turn_manager

# Called when the node enters the scene tree for the first time.
func _ready():
	if hud == null and OS.is_debug_build():
		hud = load("res://Common/Scenes/HUD.tscn").instance()
		add_child(hud)
		hud.connect_me(self)
		mob = Creature.new()
		mob.apply_scene(scene_override)
	else:
		mob = tile.mob
	if mob is Place:
		scene = PE.load_place(mob.scene_title)
	else:
		scene = PE.load_foe(mob.scene_title)
	hud.reset()
	$Panel.modulate.a = 0.7
	
	hud.talk(scene.hello)
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
	if mob is Creature:
		$Portrait/HP.text = "Health: " + str(mob.health)
	else:
		$Portrait/HP.hide()
		
#Passed from Map
func _on_rolled(roll:String):
	$Panel.modulate.a = 1
	if turn_manager != null:
		hud.talk("")
		if turn_manager.is_player_turn():
			if int(roll) >= 0:
				hud.talk_add_line("You hit for " + roll)
				mob.health -= int(roll)
				draw_hp()
				if mob.health <= 0:
					hud.talk_add_line("The beast is destroyed!")
					hud.next.connect_options(self, ["Leave"])
					hud.no_roll()
					if tile: tile.mob = null # Remove from save???
					return
		else:
			mob_target.hit_combat(int(roll))
			hud.talk("You were hit for %s."%roll)
		turn_manager.draw()
		hud.no_roll()
		turn_manager.do_turn()
		turn()
	else:
		var next_scene = scene.scenes[roll]
		if !(next_scene is Dictionary):
			next_scene = scene.scenes[next_scene as String]
		hud.talk(next_scene.talk)
		hud.next.connect_options(self, next_scene.options)
	
		
func turn():
	var creature:Creature = turn_manager.current()
	if creature.is_player():
		hud.talk_add_line("Roll to swing your %s." % creature.weapon_title)
		hud.rollbox.actions = creature.dmg()
		hud.next.connect_options(self, hud.next.FLEE_ONLY)
	else:
		hud.next.connect_options(self, hud.next.NEXT_FLEE)
		mob_target = hud.get_player()

#Passed from Map
func _on_Next_pressed(option:String):
	match option:
		"Fight!":
			turn_manager = TURN_MANAGER.instance()
			turn_manager.combatants = [mob, hud.get_player()]
			add_child(turn_manager)
			if tile: tile.hostile = true
			mob_target = hud.get_player()
			turn()
		"Drink":
			hud.get_player().heal_ability()
			#Character flashes?
			leave()
		"Leave":
			if tile: tile.hostile = false
			leave()
		"Flee":
			leave()
		"Next":
			_on_rolled(str(turn_manager.roll_dmg()))
		var next_scene:
			_on_rolled(next_scene)

func leave():
	hud.rollbox.empty_actions()
	hud.talk("")
	hud.next.destroy_options()
	queue_free()

	
