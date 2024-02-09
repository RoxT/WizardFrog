class_name Player
extends Resource
export(int) var max_hp
export(int) var hp
export(String) var title
export(Resource) var focus = Focus.new()
export(Resource) var abl
export(int) var arm
export(int) var id
var rng :RandomNumberGenerator
export(Resource) var weapon = Weapon.new()

#export(Resource) var sub_resource
#export(Array, String) var strings
const NAMES := ["Jules", "Glorbo", "Gneissi", "Darla"]

# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(
		new_focus=Focus.new(), new_max_hp=5, new_title="NA", new_arm=0, new_weapon=Weapon.new()):
	max_hp = new_max_hp
	hp = new_max_hp
	title = new_title
	focus = new_focus
	arm = new_arm
	abl = Abl.new()
	id = randi() #Increment during save
	rng = PE.rng
	weapon=new_weapon
	
func randomize():
	focus = PE.get_random_focus() as Focus
	weapon = load(Weapon.WEAPONS_FOLDER + focus.default_weapon + ".tres")
	max_hp=roll_3d6()
	title=NAMES[rng.randi()%NAMES.size()]
	var rolls := roll_3d6_array()
	rolls.sort()
	var i := 2
	for s in focus.stats:
		abl.set("max_"+ s, rolls[i])
		abl.set(s, rolls[i])
		i -= 1
	
func heal_ability():
	abl.heal()
	
func moved():
	hp += max(round(max_hp/2), max_hp)
	
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
	return arm + focus.nat_arm
	
func roll_3d6()->int:
	return rng.randi()%6 + rng.randi()%6 + rng.randi()%6

	
func roll_3d6_array()->Array:
	var results := []
	results.append(roll_3d6())
	results.append(roll_3d6())
	results.append(roll_3d6())
	return results	

func parse(d:Dictionary):
	for key in d.keys():
		assert(typeof(d[key]) == typeof(get(key)))
		set(key, d[key])
	var err = ResourceSaver.save("res://Data/Characters/" + title + ".tres", self)
	if err != OK:push_warning("Save failed " + str(err))
