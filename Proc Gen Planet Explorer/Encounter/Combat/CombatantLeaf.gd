extends Panel

onready var hp := $State/HP
onready var def := $State/DEF
onready var focus := $Focus
onready var name_l := $Name
onready var weapon_l := $Weapon

var combat:Combat = Combat.new()
export(Resource) var scene = Scene.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	name_l.text = scene.title
	combat.apply_scene(scene)
	draw()
	
func draw():
	hp.text = PE.stat_to_string("hp", combat)
	def.text = str(combat.armour())
	
func dmg_array()->Array:
	return combat.dmg

func initiative()->int:
	return combat.abl.dex

func hit_deadly(amount:int):
	combat.hit_deadly(amount)

func hit_combat(amount:int):
	combat.hit_combat(amount)
	
