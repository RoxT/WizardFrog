class_name Scene
extends Resource
export var title := "Foe"
export var texture := "icon.png"
export var hp := 1
export var dex := 10
export var str_ := 10
export var wil := 10
export var hello := "It sees you. Roll for temperment."
export var dmg := [1,2,3,4,5,6]
export(Dictionary) var intro = {roll = ["H", "C", "I", "W", "R", "O"] }
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
func _init(new_title="Foe", new_texture="icon.png", new_hp=1, new_hello="It sees you. Roll for temperment.", new_dmg=[], new_intro={roll=[1,2,3,4,5,6]}, new_scenes={}, new_sound="", new_dex=10, new_str_=10, new_wil=10):
	title = new_title
	texture = new_texture
	hp = new_hp
	hello = new_hello
	dmg = new_dmg
	intro = new_intro
	scenes = new_scenes
	sound = new_sound
	dex = new_dex
	str_ = new_str_
	wil = new_wil

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
