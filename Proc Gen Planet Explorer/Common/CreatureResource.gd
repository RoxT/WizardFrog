class_name Creature
#A Savable, Attackable file for scenes and players
extends Encounterable
export(Resource) var abl = Abl.new()
export(String) var scene_title = ""
export(String) var focus_title = ""
export(String) var weapon_title = ""
export(Array) var _dmg = [0,1,2,3,4,5]
export(int) var armour = 0
export(int) var health = 3
export(int) var max_health = 3

# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init():
	pass
	
func is_player()->bool:
	return !focus_title.empty() 

func heal_abilities():
	abl.heal()
	
func dmg()->Array:
	return _dmg
	
func hit_deadly(amount:int)->bool:
	if health-amount <0:
		health = 0
		abl.str_ += (health-amount)
		return true
	return false
	
func hit_combat(amount:int):
	if health-amount <0:
		health = 0
		return true
	return false
	
static func initiative(a, b)->bool:
	if a.abl.dex < b.abl.dex:
		return true
	else: return false

func apply_scene(new_scene:Scene):
	title = new_scene.title
	scene_title = new_scene.title
	abl = Abl.new()
	abl.scene(new_scene)
	_dmg = new_scene.dmg
	max_health = new_scene.hp
	health = new_scene.hp
	texture_location = new_scene.texture
	
func apply_player(new_name:String, new_abl:Abl, new_focus:Focus, new_weapon:Weapon=null):
	title = new_name
	abl = new_abl
	
	focus_title = new_focus.title
	armour = new_focus.nat_arm
	max_health = abl.mod("str_") + abl.mod("wil") + abl.mod("dex")
	health = max_health
	
	if new_weapon == null:
		new_weapon = PE.load_weapon(new_focus.default_weapon)
	weapon_title = new_weapon.title
	_dmg = new_weapon.rolls
