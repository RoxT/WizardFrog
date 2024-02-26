extends Panel

onready var hp := $State/HP
onready var def := $State/DEF
onready var name_l := $Name

var creature:Creature = Creature.new()
export(Resource) var scene_override

# Called when the node enters the scene tree for the first time.
func _ready():
	if scene_override != null:
		creature = Creature.new()
		creature.apply_scene(scene_override)
	name_l.text = creature.title
	draw()
	
func draw():
	hp.text = PE.stat_to_string("health", creature)
	def.text = str(creature.armour)
	
func dmg_array()->Array:
	return creature.dmg

func initiative()->int:
	return creature.abl.dex

func hit_deadly(amount:int):
	creature.hit_deadly(amount)

func hit_combat(amount:int):
	creature.hit_combat(amount)
	
