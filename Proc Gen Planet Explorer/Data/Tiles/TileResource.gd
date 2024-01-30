class_name Tile
extends Resource
export var title := "Mountain"
export var texture := "mountains.svg"
export var rations := 3
export var has_water := false
export var settlement := false
export var sound := "quiet_frogs.ogg"
export var outcomes := ["Discovery", "Encounter", "Encounter"]
const TILES_FOLDER  := "res://Data/Tiles/"
const CITIES_FOLDER := "res://Data/Tiles/Settlements/"
const TILES_JSON  := "res://Data/Tiles/tiles.json"
const CITIES_JSON := "res://Data/Tiles/Settlements/settlement_tiles.json"

# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(new_title:="Mountains", new_texture:="mountains.svg", new_rations:=3, new_has_water=false, new_settlement=false, new_sound:="", new_outcomes=["Discovery", "Encounter", "Encounter"]):
	title = new_title
	texture = new_texture
	rations = new_rations
	has_water = new_has_water
	settlement = new_settlement
	sound = new_sound
	outcomes = new_outcomes
	
func load_outcomes()->Array:
	var value := []
	value.resize(6)
	value.fill("Nothing")
	for i in range(outcomes.size()):
		value[5-i] = outcomes[outcomes.size()-1-i]
	return value

func load_texture()->Texture:
	return load("res://Map/" + texture) as Texture

func load_sound_or_null():
	if sound == "": return null
	return load("res://Map/Sounds/" + sound) as AudioStreamOGGVorbis

func parse(d:Dictionary, folder:String):
	for key in d.keys():
		assert(get(key) != null)
		assert(typeof(d[key]) == typeof(get(key)))
		assert(load_texture() != null)
		set(key, d[key])
	var err = ResourceSaver.save(folder + title + ".tres", self)
	if err != OK:push_warning("Save failed " + str(err))
