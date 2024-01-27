extends Control


var _scene_data:Dictionary
# Called when the node enters the scene tree for the first time.
func _ready():
	parse_scenes()
	parse_map_tiles()
	parse_cities()
#	load_scene("res://DictTest/Friend.json")
#	$Label.text = str(_scene_data)
#	_store_scene_data(_scene_data, "res://DictTest/result.scene")
#	load_scene("res://DictTest/result.scene")
#	$Label2.text = str(_scene_data)

func parse_cities():
	var file := File.new()
	var err = file.open("res://DictTest/OneOffs/settlement_tiles.json", File.READ)
	if err != OK: push_error("Error opening file " + str(err))
	var scenes:Array = str2var(file.get_as_text())
	for s in scenes:
		var new = Tile.new()
		new.parse(s, "SettlementTiles")
		var tex := TextureRect.new()
		tex.texture = new.load_texture()
		$HFlowContainer.add_child(tex)
		print(str(new))
	file.close()	
	
func parse_scenes():
	var file := File.new()
	var err = file.open("res://DictTest/Friends.json", File.READ)
	if err != OK: push_error("Error opening file " + str(err))
	var scenes:Array = str2var(file.get_as_text())
	for s in scenes:
		var new = Scene.new()
		new.parse(s)
		var tex := TextureRect.new()
		tex.texture = new.load_texture()
		$HFlowContainer.add_child(tex)
		print(str(new))
	file.close()

func parse_map_tiles():
	var file := File.new()
	var err = file.open("res://DictTest/tiles.json", File.READ)
	if err != OK: push_error("Error opening file " + str(err))
	var scenes:Array = str2var(file.get_as_text())
	for s in scenes:
		var new = Tile.new()
		new.parse(s, "Tiles")
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
