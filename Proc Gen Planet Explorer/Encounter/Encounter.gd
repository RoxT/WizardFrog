extends CanvasLayer

onready var portrait := $Portrait
onready var audio_player := $AudioStreamPlayer
const PATH := "res://%s"
export(Resource) var scene_override

var hud
var scene:Scene
var mob:Encounterable
var tile:Control
var turns := []
var turn_i := 0
var mob_target

# Called when the node enters the scene tree for the first time.
func _ready():
	if hud == null: #Debug Mode
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
	if mob is Creature:
		$Portrait/HP.text = "Health: " + str(mob.health)
	else:
		$Portrait/HP.hide()
		
#Passed from Map
func _on_rolled(roll:String):
	$Panel.modulate.a = 1
	if !turns.empty():
		hud.talk.text = ""
		if turns[turn_i].is_player():
			if int(roll) >= 0:
				hud.talk.add_text("You hit for " + roll)
				hud.talk.newline()
				mob.health -= int(roll)
				draw_hp()
				if mob.health <= 0:
					hud.talk.add_text("The beast is destroyed!")
					hud.next.connect_options(self, ["Leave"])
					hud.no_roll()
					if tile: tile.mob = null # Remove from save???
					return
		else:
			mob_target.hit_combat(int(roll))
			hud.talk.text = "You were hit for %s."%roll
		turn(turns[turn_i])
	else:
		var next_scene = scene.scenes[roll]
		if !(next_scene is Dictionary):
			next_scene = scene.scenes[next_scene as String]
		hud.talk.text = next_scene.talk
		hud.next.connect_options(self, next_scene.options)
	
		
func turn(creature:Creature):
	turn_i = (turn_i + 1)%turns.size()
	if creature.is_player():
		hud.talk.add_text("Roll to swing your %s." % creature.weapon_title)
		hud.rollbox.actions = creature.dmg()
		hud.next.connect_options(self, ["Flee"])
	else:
		hud.next.connect_options(self, ["Next"])
		mob_target = hud.player_leaf

#Passed from Map
func _on_Next_pressed(option:String):
	match option:
		"Fight!": 
			turns = [hud.get_player(), mob]
			turns.sort_custom(Creature, "initiative")
			$TurnManager.combatants = turns
			if tile: tile.hostile = true
			_on_rolled("-1")
			hud.next.connect_options(self, ["Flee"])
			mob_target = hud.player_leaf
		"Drink":
			hud.get_player().heal_ability()
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

	
