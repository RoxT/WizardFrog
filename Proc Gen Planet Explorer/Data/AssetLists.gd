
extends Resource
export(Array) var focuses = []
export(Array) var weapons = []
export(Array) var scenes = []
export(Array) var discoveries = []
export(Array) var cities = []
export(Array) var tiles = []

const PATH := "res://Data/AssetLists.tres"


# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init():
	pass

func save():
	var err = ResourceSaver.save(PATH, self)
	assert(err == OK)
	


func _get_all_of(list:Array, folder:String):
	var results := {}
	for t in list:
		results[t] = load(folder.plus_file(t + ".tres"))
	return results

func get_all_tiles()->Dictionary:
	return _get_all_of(tiles, Tile.TILES_FOLDER)

func get_all_places()->Dictionary:
	return _get_all_of(discoveries, Scene.DISCOVERIES_FOLDER)
	
func _get_random(list:Array, folder:String)->Resource:
	return load(folder + list[randi()%list.size()] + ".tres")
	
func get_random_focus()->Focus:
	return _get_random(focuses, Focus.CHARACTERS_FOLDER) as Focus

func get_random_settlement()->Tile:
	return _get_random(cities, Tile.CITIES_FOLDER) as Tile
	
func get_random_place()->Scene:
	return _get_random(discoveries, Scene.DISCOVERIES_FOLDER) as Scene
	
func get_random_foe()->Scene:
	return _get_random(scenes, Scene.SCENES_FOLDER) as Scene
	
