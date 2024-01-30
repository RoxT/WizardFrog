class_name Scene
extends Resource
export var title := "Foe"
export var texture := "icon.png"
export var hp := 1
export var hello := "It sees you. Roll for temperment."
export var intro := ["H", "C", "I", "W", "R", "O"]
export var scenes := {}
export var sound := "quiet_frogs.ogg"
const SCENES_FOLDER := "res://Data/Scenes/"
const SCENES_JSON := "res://Data/Scenes/Friends.json"
const DISCOVERIES_JSON := "res://Data/Scenes/Discoveries/Places.json"
const DISCOVERIES_FOLDER := "res://Data/Scenes/Discoveries/"
#export(Resource) var sub_resource
#export(Array, String) var strings

# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(new_title="Foe", new_texture="icon.png", new_hp=1, new_hello="It sees you. Roll for temperment.", new_intro=["H", "C", "I", "W", "R", "O"], new_scenes={}, new_sound=""):
	title = new_title
	texture = new_texture
	hp = new_hp
	hello = new_hello
	intro = new_intro
	scenes = new_scenes
	sound = new_sound

func load_texture()->Texture:
	return load("res://" + texture) as Texture

func load_sound_or_null():
	if sound == "": return null
	return load("res://Encounter/Sounds/" + sound) as AudioStreamOGGVorbis

func parse(d:Dictionary, folder:String):
	for key in d.keys():
		if get(key) == null:
			scenes[key] = d[key]
		else:
			assert(typeof(d[key]) == typeof(get(key)))
			set(key, d[key])
	var err = ResourceSaver.save(folder + title + ".tres", self)
	if err != OK:push_warning("Save failed " + str(err))
