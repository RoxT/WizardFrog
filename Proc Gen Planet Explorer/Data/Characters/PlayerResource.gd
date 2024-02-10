class_name Player extends Resource
export(String) var title
export(int) var id
var rng :RandomNumberGenerator
export(Resource) var weapon = Weapon.new()

export(Resource) var combat = Combat.new()
export(Resource) var focus = Focus.new()
var nat_armour

#export(Resource) var sub_resource
#export(Array, String) var strings
const NAMES := ["Jules", "Glorbo", "Gneissi", "Darla"]

# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(
		new_focus=Focus.new(), new_max_hp=5, new_title="NA", new_weapon=Weapon.new()):
	weapon=new_weapon
	focus = new_focus
	combat = Combat.new(new_max_hp, focus.nat_arm, weapon.rolls)
	title = new_title
	id = randi() #Increment during save
	rng = PE.rng
		
	
func randomize():
	focus = PE.get_random_focus() as Focus
	title=NAMES[rng.randi()%NAMES.size()]
	
	var rolls := roll_3d6_array()
	rolls.sort()
	var i := 2
	var abl = Abl.new()
	for s in focus.stats:
		abl.set("max_"+ s, rolls[i])
		abl.set(s, rolls[i])
		i -= 1
		
	weapon = load(Weapon.WEAPONS_FOLDER + focus.default_weapon + ".tres")
	combat = Combat.new(roll_3d6(), focus.nat_arm, weapon.rolls, abl)
	
func moved():
	combat.hp += max(round(combat.max_hp/2), combat.max_hp)

func armour()->int:
	return combat.arm + focus.nat_arm
	
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
