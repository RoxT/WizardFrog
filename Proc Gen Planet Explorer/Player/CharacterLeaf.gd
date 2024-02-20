extends Panel

onready var str_ := $Stats/STR
onready var dex := $Stats/DEX
onready var wil := $Stats/WIL
onready var hp := $State/HP
onready var def := $State/DEF
onready var focus := $Focus
onready var name_l := $Name
onready var weapon_l := $Weapon

var combat:Combat = Combat.new()
export(Resource) var player = Player.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	if player == null: player = PE.new_random_player()
	name_l.text = player.title
	focus.text = player.focus.title
	weapon_l.text = player.weapon.title
	draw()
	
func draw():
	str_.text = PE.stat_to_string("str_", combat.abl)
	dex.text = PE.stat_to_string("dex", combat.abl)
	wil.text = PE.stat_to_string("wil", combat.abl)
	
	hp.text = PE.stat_to_string("hp", combat)
	def.text = str(armour())
	
func dmg_array()->Array:
	return combat.dmg

func initiative()->int:
	return combat.abl.dex

func hit_deadly(amount:int):
	combat.hit_deadly(amount)

func hit_combat(amount:int):
	combat.hit_combat(amount)
	
func moved():
	combat.hp += max(round(combat.max_hp/2), combat.max_hp)
	

func armour()->int:
	return combat.arm + player.focus.nat_arm
	
