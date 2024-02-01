extends Panel

onready var str_ := $Stats/STR
onready var dex := $Stats/DEX
onready var wil := $Stats/WIL
onready var hp := $State/HP
onready var def := $State/DEF
onready var focus := $Focus
onready var name_l := $Name

var player:Player

# Called when the node enters the scene tree for the first time.
func _ready():
	if player == null: player = PE.new_random_player()
	name_l.text = player.title
	focus.text = player.focus.title
	
	str_.text = player.stat_to_string("str_")
	dex.text = player.stat_to_string("dex")
	wil.text = player.stat_to_string("wil")
	
	hp.text = player.stat_to_string("hp")
	def.text = str(player.armour())


