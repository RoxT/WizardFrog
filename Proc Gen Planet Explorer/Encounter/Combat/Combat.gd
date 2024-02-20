class_name Combat
extends Resource
export(int) var max_hp setget set_max_hp
export(int) var hp
export(int) var arm setget ,armour
export var dmg := [1,2,3,4,5,6]
export(Resource) var abl = Abl.new()

# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(new_max_hp=5, new_abl=Abl.new(), new_arm=0):
	max_hp = new_max_hp
	hp = new_max_hp
	arm = new_arm
	abl = new_abl
	
func apply_scene(s:Scene):
	abl = Abl.new()
	abl = abl.scene(s)
	max_hp = s.hp
	hp = max_hp
	arm = max(abl.mod(Abl.WIL), abl.mod(Abl.DEX))
	dmg = s.dmg
	
func heal_ability():
	abl.heal()

static func initiative(a, b)->bool:
	if a.combat.abl.dex < b.combat.abl.dex:
		return true
	else: return false

func hit_deadly(amount:int)->bool:
	if hp-amount <0:
		hp = 0
		abl.str_ += (hp-amount)
		return true
	return false
	
func hit_combat(amount:int):
	if hp-amount <0:
		hp = 0
		return true
	return false
	
func armour()->int:
	return arm

func set_max_hp(value:int):
	max_hp = value
	hp = value
