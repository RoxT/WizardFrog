extends Panel

onready var str_ := $Stats/STR
onready var dex := $Stats/DEX
onready var wil := $Stats/WIL
onready var hp := $State/HP
onready var def := $State/DEF
onready var focus := $Focus
onready var name_l := $Name
onready var weapon_l := $Weapon

export(Resource) var creature

# Called when the node enters the scene tree for the first time.
func _ready():
	if creature == null: creature = PE.new_random_player_creature()
	name_l.text = creature.title
	focus.text = creature.focus_title
	weapon_l.text = creature.weapon_title
	draw()
	
func draw():
	str_.text = PE.stat_to_string("str_", creature.abl)
	dex.text = PE.stat_to_string("dex", creature.abl)
	wil.text = PE.stat_to_string("wil", creature.abl)
	
	hp.text = PE.stat_to_string("health", creature)
	def.text = str(armour())
	
func dmg_array()->Array:
	return creature.dmg

func initiative()->int:
	return creature.abl.dex

func hit_deadly(amount:int):
	creature.hit_deadly(amount)

func hit_combat(amount:int):
	creature.hit_combat(amount)
	
func moved():
	creature.health += max(round(creature.max_health/2), creature.max_health)
	

func armour()->int:
	return creature.armour
	
