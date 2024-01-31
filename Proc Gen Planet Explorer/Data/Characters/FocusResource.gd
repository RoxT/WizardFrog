class_name Focus
extends Resource
export(String) var title
export(Array) var stats = ["str", "dex", "wil"]
export(int) var nat_arm
export(String) var ability
const CHARACTERS_FOLDER := "res://Data/Characters/"
const FOCUSES_JSON  := "res://Data/Characters/focuses.json"

# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(new_title="Unknown", new_stats=["str", "dex", "wil"], new_nat_arm=1, new_ability="Undescribed"):
	title = new_title
	stats = new_stats
	nat_arm = new_nat_arm
	ability = new_ability
	
func parse(d:Dictionary):
	for key in d.keys():
		assert(get(key) != null)
		assert(typeof(d[key]) == typeof(get(key)))
		set(key, d[key])
	var err = ResourceSaver.save(CHARACTERS_FOLDER + title + ".tres", self)
	if err != OK:push_warning("Save failed " + str(err))
