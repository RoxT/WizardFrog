class_name Weapon
extends Resource
export(String) var title
export(Array) var rolls = [0,0,0,0,0,0]
export(float) var average
const WEAPONS_JSON := "res://Data/Characters/Weapons/weapons.json"
const WEAPONS_FOLDER := "res://Data/Characters/Weapons/"

# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(new_title="NA", new_rolls=[1,2,3,4,5,6]):
	assert(new_rolls.size()==6)
	title = new_title
	rolls = new_rolls
	average_rolls()

func parse(d:Dictionary):
	for key in d.keys():
		assert(typeof(d[key]) == typeof(get(key)))
		set(key, d[key])
	average_rolls()
	var err = ResourceSaver.save(WEAPONS_FOLDER + title + ".tres", self)
	if err != OK:push_warning("Save failed " + str(err))

func average_rolls():
	assert(rolls.size()==6)
	for r in rolls:
		average += r
	average = average/6
