extends Panel

onready var str_ := $Stats/STR
onready var dex := $Stats/DEX
onready var wil := $Stats/WIL
onready var hp := $State/HP
onready var def := $State/DEF
onready var focus := $Focus
onready var name_l := $Name
onready var weapon_l := $Weapon

var player:Player

# Called when the node enters the scene tree for the first time.
func _ready():
	if player == null: player = PE.new_random_player()
	name_l.text = player.title
	focus.text = player.focus.title
	weapon_l.text = player.weapon.title
	draw()
	
func draw():
	str_.text = PE.stat_to_string("str_", player.combat.abl)
	dex.text = PE.stat_to_string("dex", player.combat.abl)
	wil.text = PE.stat_to_string("wil", player.combat.abl)
	
	hp.text = PE.stat_to_string("hp", player.combat)
	def.text = str(player.armour())
	
func dmg_array()->Array:
	return player.combat.dmg

func initiative()->int:
	return player.combat.abl.dex

func hit_deadly(amount:int):
	player.combat.hit_deadly(amount)

func hit_combat(amount:int):
	player.combat.hit_combat(amount)
	
