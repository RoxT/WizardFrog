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
	
	str_.text = PE.stat_to_string("str_", player)
	dex.text = PE.stat_to_string("dex", player)
	wil.text = PE.stat_to_string("wil", player)
	
	hp.text = PE.stat_to_string("hp", player)
	def.text = str(player.armour())


