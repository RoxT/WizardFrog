extends Control

const ASSET_LISTS := preload("res://Data/AssetLists.gd")
var lists

var _scene_data:Dictionary
# Called when the node enters the scene tree for the first time.
func _ready():
	lists = ASSET_LISTS.new()
	parse_scenes()
	parse_discoveries()
	parse_map_tiles()
	parse_cities()
	parse_focuses()
	parse_weapons()
	lists.save()

func parse_weapons():
	lists.weapons = []
	for w in open_file_to_var(Weapon.WEAPONS_JSON):
		var new = Weapon.new()
		new.parse(w)
		lists.weapons.append(new.title)
		proof(new)
		
func proof(thing):
	if thing.get("texture") != null:
		var tex := TextureRect.new()
		tex.texture = thing.load_texture()
		$ScrollContainer/HFlowContainer.add_child(tex)
	else:
		var tex := Label.new()
		tex.text = thing.title
		$ScrollContainer/HFlowContainer.add_child(tex)

func open_file_to_var(filename:String)->Array:
	var file := File.new()
	var err = file.open(filename, File.READ)
	if err != OK: push_error("Error opening file " + str(err))
	var values := str2var(file.get_as_text()) as Array
	file.close()
	return values

func parse_focuses():
	var scenes:Array = open_file_to_var(Focus.FOCUSES_JSON)
	lists.focuses = []
	for s in scenes:
		var new = Focus.new()
		new.parse(s)
		lists.focuses.append(new.title)
		proof(new)

func parse_discoveries():
	var scenes:Array = open_file_to_var(Scene.DISCOVERIES_JSON)
	lists.discoveries = []
	for s in scenes:
		var new = Scene.new()
		new.parse(s, Scene.DISCOVERIES_FOLDER)
		lists.discoveries.append(new.title)
		proof(new)

func parse_cities():
	var scenes:Array = open_file_to_var(Tile.CITIES_JSON)
	lists.cities = []
	for s in scenes:
		var new = Tile.new()
		new.parse(s, Tile.CITIES_FOLDER)
		lists.cities.append(new.title)
		proof(new)
	
func parse_scenes():
	var scenes:Array = open_file_to_var(Scene.SCENES_JSON)
	lists.scenes = []
	for s in scenes:
		var new = Scene.new()
		new.parse(s, Scene.SCENES_FOLDER)
		lists.scenes.append(new.title)
		proof(new)

func parse_map_tiles():
	var scenes:Array = open_file_to_var(Tile.TILES_JSON)
	lists.tiles = []
	for s in scenes:
		var new = Tile.new()
		new.parse(s, Tile.TILES_FOLDER)
		lists.tiles.append(new.title)
		proof(new)

func load_scene(file_path: String) -> void:
	var file := File.new()
	var err = file.open(file_path, File.READ)
	if err != OK: push_error("Error opening file " + str(err))
	_scene_data = str2var(file.get_as_text())
	
	file.close()

func _store_scene_data(data: Dictionary, path: String) -> void:
	var file := File.new()
	var err = file.open(path, File.WRITE)
	if err != OK: push_error("Error opening file " + str(err))
	file.store_string(var2str(data))
	file.close()
