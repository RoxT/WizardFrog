extends Node

const TILE_SIZE := Vector2(128, 128)

const ASSET_LISTS := preload("res://Data/AssetLists.gd")
var rng := RandomNumberGenerator.new()
const NAMES := ["Jules", "Glorbo", "Gneissi", "Darla"]

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	
func new_random_player_creature()->Creature:
	var result = Creature.new()
	var focus:Focus = PE.get_random_focus()
	
	var rolls := Abl.roll_3d6_array()
	rolls.sort()
	var i := 2
	var abl = Abl.new()
	for s in focus.stats:
		abl.set("max_"+ s, rolls[i])
		abl.set(s, rolls[i])
		i -= 1
		
	# new_name:String, new_abl:Abl, new_focus:Focus, new_weapon:Weapon
	result.apply_player(draw(NAMES), abl, focus)
	
	return result

func load_foe(title:String)->Scene:
	return load("res://Data/Scenes/%s.tres" % title) as Scene
	
func load_place(title:String)->Scene:
	return load("res://Data/Scenes/Discoveries/%s.tres" % title) as Scene
	

func get_random_focus()->Focus:
	return load_asset_list().get_random_focus()
	
func load_weapon(title:String)->Weapon:
	return load(Weapon.WEAPONS_FOLDER + title + ".tres") as Weapon

func get_random_settlement()->Tile:
	return load_asset_list().get_random_settlement()

static func stat_to_string(stat:String, target:Resource)->String:
	if target.get(stat) != target.get("max_" + stat):
		var out_of:String = str(target.get("max_" + stat))
		return str(target.get(stat)) + "/" + out_of
	else:
		return str(target.get(stat))
		
static func load_asset_list()->Resource:
	return load(ASSET_LISTS.PATH)

func get_all_tiles()->Dictionary:
	return load_asset_list().get_all_tiles()
	
func get_all_places()->Dictionary:
	return load_asset_list().get_all_places()
	
func get_random_place()->Scene:
	return load_asset_list().get_random_place()

func get_random_foe()->Scene:
	return load_asset_list().get_random_foe()
	
func draw(container)->Resource:
	if container is Dictionary:
		return container[_draw_array(container.keys())]
	if container is Array:
		return container[randi() % container.size()]
	push_error("Can only draw from Array or Dictionary")
	return null
	
func _draw_array(array:Array)->Resource:
	return array[randi() % array.size()]

func get_all_foes()->Array:
	# from https://gdquest.mavenseed.com/lessons/the-resource-database
	var DIRECTORY_PATH := "res://Data/Scenes/"
	var directory := Directory.new()
	if directory.open(DIRECTORY_PATH) != OK:
		return []

	var resources := []

	var err = directory.list_dir_begin()
	if err != OK: push_error("Directory error " + str(err))
	var filename = directory.get_next()
	while filename != "":
		# Note that we only loop over only one directory; we don't explore
		# subdirectories.
		if filename.ends_with(".tres"):
			# `String.plus_file()` safely concatenate paths following Godot's
			# virtual filesystem.
			var resource: Resource = load(DIRECTORY_PATH.plus_file(filename))

			# Here's where we check the resource's type. If it doesn't match the
			# one we expect, we skip it.
			# Resources are reference-counted so as the local variable
			# `resource` clears, Godot frees the object from memory.
			if not (resource is Scene):
				continue

			# If the resource passes the type check, we store it.
			resources.append(resource)
		filename = directory.get_next()
	directory.list_dir_end()

	return resources
