class_name Scene
extends Resource
export var title := "Foe"
export var texture := "icon.png"
export var hp := 1
export var hello := "It sees you. Roll for temperment."
export var intro := ["H", "C", "I", "W", "R", "O"]
export var scenes := {}
#export(Resource) var sub_resource
#export(Array, String) var strings

# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(new_title="Foe", new_texture="icon.png", new_hp=1, new_hello="It sees you. Roll for temperment.", new_intro=["H", "C", "I", "W", "R", "O"], new_scenes={}):
	title = new_title
	texture = new_texture
	hp = new_hp
	hello = new_hello
	intro = new_intro
	scenes = new_scenes

func load_texture()->Texture:
	return load("res://" + texture) as Texture

func parse(d:Dictionary):
	for key in d.keys():
		if get(key) == null:
			scenes[key] = d[key]
		else:
			assert(typeof(d[key]) == typeof(get(key)))
			set(key, d[key])
	var err = ResourceSaver.save("res://DictTest/Scenes/" + title + ".tres", self)
	if err != OK:push_warning("Save failed " + str(err))
