class_name Player extends Resource
export(String) var title
export(int) var id
var rng :RandomNumberGenerator
export(Resource) var weapon = Weapon.new()

export(Resource) var focus = Focus.new()
var nat_armour

#export(Resource) var sub_resource
#export(Array, String) var strings


# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(
		new_focus=Focus.new(), new_title="NA", new_weapon=Weapon.new()):
	weapon=new_weapon
	focus = new_focus
	title = new_title
	id = randi() #Increment during save
	rng = PE.rng
		
	
func randomize():

		
	weapon = load(Weapon.WEAPONS_FOLDER + focus.default_weapon + ".tres")
	

	
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
