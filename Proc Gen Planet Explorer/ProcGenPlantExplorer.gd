extends Node

const TILE_SIZE := Vector2(128, 128)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func load_foe(title:String)->Scene:
	return load("res://Data/Scenes/%s.tres" % title) as Scene

func get_random_settlement()->Tile:
	var DIRECTORY_PATH := "res://Data/Tiles/Settlements/"
	var directory := Directory.new()
	if directory.open(DIRECTORY_PATH) != OK:
		return null

	var resources := []

	var err = directory.list_dir_begin()
	if err != OK: push_error("Directory error " + str(err))
	var filename = directory.get_next()
	while filename != "":
		if filename.ends_with(".tres"):
			var resource: Resource = load(DIRECTORY_PATH.plus_file(filename))
			if not (resource is Tile):
				continue
			resources.append(resource)
		filename = directory.get_next()
	directory.list_dir_end()
	return resources[randi() % resources.size()]
	

func get_all_tiles()->Dictionary:
	# from https://gdquest.mavenseed.com/lessons/the-resource-database
	var DIRECTORY_PATH := "res://Data/Tiles/"
	var directory := Directory.new()
	if directory.open(DIRECTORY_PATH) != OK:
		return {}

	var resources := {}

	var err = directory.list_dir_begin()
	if err != OK: push_error("Directory error " + str(err))
	var filename = directory.get_next()
	while filename != "":
		if filename.ends_with(".tres"):
			var resource: Resource = load(DIRECTORY_PATH.plus_file(filename))
			if not (resource is Tile):
				continue

			resources[resource.title] = resource
		filename = directory.get_next()
	directory.list_dir_end()

	return resources

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


