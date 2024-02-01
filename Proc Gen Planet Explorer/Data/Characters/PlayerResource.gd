class_name Player
extends Resource
export(int) var max_hp
export(int) var hp
export(String) var title
export(Resource) var focus
export(int) var max_str_
export(int) var max_dex
export(int) var max_wil
export(int) var str_
export(int) var dex
export(int) var wil
export(int) var arm
export(int) var id

#export(Resource) var sub_resource
#export(Array, String) var strings
const NAMES := ["Jules", "Glorbo", "Gneissi", "Darla"]

# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(
	new_focus=Focus.new(), new_max_hp=randi()%6, new_title=NAMES[randi()%NAMES.size()], 
	new_arm=0):
	max_hp = new_max_hp
	hp = new_max_hp
	title = new_title
	focus = new_focus
	var rolls := roll_3d6()
	rolls.sort()
	var i := 2
	for s in new_focus.stats:
		set("max_"+ s, rolls[i])
		i -= 1
	str_ = max_str_
	dex = max_dex
	wil = max_wil
	arm = new_arm
	id = randi()
	

func stat_to_string(stat:String)->String:
	if get(stat) != get("max_" + stat):
		return str(get(stat)) + "/" + str(get("max_" + get(stat)))
	else:
		return str(get(stat))
	
func moved():
	hp += max(round(max_hp/2), max_hp)
	
func hit_deadly(amount:int)->bool:
	if hp-amount <0:
		hp = 0
		str_ += (hp-amount)
		return true
	return false

func hit_combat(amount:int):
	if hp-amount <0:
		hp = 0
		return true
	return false
	
func armour()->int:
	return arm + focus.nat_arm
	
static func roll_3d6()->Array:
	var rng = PE.rng
	rng.randomize()
	var results := []
	results.append(rng.randi()%6 + rng.randi()%6 + rng.randi()%6)
	results.append(rng.randi()%6 + rng.randi()%6 + rng.randi()%6)
	results.append(rng.randi()%6 + rng.randi()%6 + rng.randi()%6)
	return results

func parse(d:Dictionary):
	for key in d.keys():
		assert(typeof(d[key]) == typeof(get(key)))
		set(key, d[key])
	var err = ResourceSaver.save("res://Data/Characters/" + title + ".tres", self)
	if err != OK:push_warning("Save failed " + str(err))
