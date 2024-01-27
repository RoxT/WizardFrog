class_name Tile
extends Resource
export var title := "Mountain"
export var texture := "mountains.svg"
export var rations := 3
export var has_water := false
export var settlement := false
const PATH := "res://Map/%s/%s.tres"

# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(new_title:="Mountains", new_texture:="mountains.svg", new_rations:=3, new_has_water=false, new_settlement=false):
	title = new_title
	texture = new_texture
	rations = new_rations
	has_water = new_has_water
	settlement = new_settlement

func load_texture()->Texture:
	return load("res://Map/" + texture) as Texture

func parse(d:Dictionary, subfolder:String):
	for key in d.keys():
		assert(get(key) != null)
		assert(typeof(d[key]) == typeof(get(key)))
		assert(load_texture() != null)
		set(key, d[key])
	var err = ResourceSaver.save(PATH % [subfolder, title], self)
	if err != OK:push_warning("Save failed " + str(err))
