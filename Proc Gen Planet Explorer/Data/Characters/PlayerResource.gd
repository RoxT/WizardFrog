class_name Player
extends Resource
export(int) var max_hp
export(int) var hp
export(String) var title
export(Resource) var focus
export(int) var max_str
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
	new_max_str=10, new_max_dex=10, new_max_wil=10, new_arm=0):
	max_hp = new_max_hp
	hp = new_max_hp
	title = new_title
	focus = new_focus
	var stats := roll_3d6()
	stats.sort()
	var i := 2
	for s in new_focus.stats:
		set(s, i)
		i -= 1
	max_str = new_max_str
	max_dex = new_max_dex
	max_wil = new_max_wil
	str_ = new_max_str
	dex = new_max_dex
	wil = new_max_wil
	arm = new_arm
	id = randi()
	
func armour()->int:
	return arm + focus.nat_arm
	
static func roll_3d6()->Array:
	var results := []
	results.append(randi()%6 + randi()%6 + randi()%6)
	results.append(randi()%6 + randi()%6 + randi()%6)
	results.append(randi()%6 + randi()%6 + randi()%6)
	return results

func parse(d:Dictionary):
	for key in d.keys():
		assert(typeof(d[key]) == typeof(get(key)))
		set(key, d[key])
	var err = ResourceSaver.save("res://Data/Characters/" + title + ".tres", self)
	if err != OK:push_warning("Save failed " + str(err))
