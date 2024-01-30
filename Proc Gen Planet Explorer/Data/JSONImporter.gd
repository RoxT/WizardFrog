extends Control


var _scene_data:Dictionary
# Called when the node enters the scene tree for the first time.
func _ready():
	parse_scenes()
	parse_discoveries()
	parse_map_tiles()
	parse_cities()

func parse_discoveries():
	var file := File.new()
	var err := file.open(Scene.DISCOVERIES_JSON, File.READ)
	if err != OK: push_error("Error opening file " + str(err))
	var scenes:Array = str2var(file.get_as_text())
	for s in scenes:
		var new = Scene.new()
		new.parse(s, Scene.DISCOVERIES_FOLDER)
		var tex := TextureRect.new()
		tex.texture = new.load_texture()
		$HFlowContainer.add_child(tex)
		print(str(new))
	file.close()

func parse_cities():
	var file := File.new()
	var err = file.open(Tile.CITIES_JSON, File.READ)
	if err != OK: push_error("Error opening file " + str(err))
	var scenes:Array = str2var(file.get_as_text())
	for s in scenes:
		var new = Tile.new()
		new.parse(s, Tile.CITIES_FOLDER)
		var tex := TextureRect.new()
		tex.texture = new.load_texture()
		$HFlowContainer.add_child(tex)
		print(str(new))
	file.close()	
	
func parse_scenes():
	var file := File.new()
	var err := file.open(Scene.SCENES_JSON, File.READ)
	if err != OK: push_error("Error opening file " + str(err))
	var scenes:Array = str2var(file.get_as_text())
	for s in scenes:
		var new = Scene.new()
		new.parse(s, Scene.SCENES_FOLDER)
		var tex := TextureRect.new()
		tex.texture = new.load_texture()
		$HFlowContainer.add_child(tex)
		print(str(new))
	file.close()

func parse_map_tiles():
	var file := File.new()
	var err = file.open(Tile.TILES_JSON, File.READ)
	if err != OK: push_error("Error opening file " + str(err))
	var scenes:Array = str2var(file.get_as_text())
	for s in scenes:
		var new = Tile.new()
		new.parse(s, Tile.TILES_FOLDER)
		var tex := TextureRect.new()
		tex.texture = new.load_texture()
		$HFlowContainer.add_child(tex)
		print(str(new))
	file.close()	

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
