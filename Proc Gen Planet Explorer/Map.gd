extends Control

onready var tiles_layer := $TilesLayer
onready var foe_layer := $FoesLayer
onready var rollbox := $HUD/RollBox
onready var player := $HUD/Player
onready var ref_rect := $HUD/ReferenceRect
onready var center := get_rect().get_center().snapped(PE.TILE_SIZE)
onready var UP := Vector2.UP * PE.TILE_SIZE
onready var DOWN := Vector2.DOWN * PE.TILE_SIZE
onready var RIGHT := Vector2.RIGHT * PE.TILE_SIZE
onready var LEFT := Vector2.LEFT * PE.TILE_SIZE
var foes := []
var places := []
var possible_tiles := {}
var cursor:Vector2
var rand := RandomNumberGenerator.new()
var tile_map := {}
var last_tile_clicked:TextureButton

# To save:
var rations := 10

# Called when the node enters the scene tree for the first time.
func _ready():
	$HUD/Talk.hide()
	rand.randomize()
	foes = PE.get_all_foes()
	places = PE.get_all_places()
	cursor = center.snapped(PE.TILE_SIZE)
	place_tile(cursor, PE.get_random_settlement() as Tile)
	tile_map[cursor].visited = true
	move_player(cursor)
	possible_tiles = PE.get_all_tiles()
	for _i in range(20):
		place_tile(cursor)
		cursor += [UP, DOWN, LEFT, RIGHT][rand.randi()%4]
		place_tile(cursor)
		cursor += [UP, DOWN, LEFT, RIGHT][rand.randi()%4]
		place_tile(cursor)
		cursor += [UP, DOWN, LEFT, RIGHT][rand.randi()%4]
		place_tile(cursor)
	var err := rollbox.connect("rolled", self, "_on_roll")
	if err != OK: push_error("Can't connect rollbox " + str(err))
	ref_rect.rect_position = center
	print("----------------")

func place_foe():
	var foe_i := rand.randi()%foes.size()
	var foe := foes[foe_i] as Scene
	place_scene(foe)
	
func place_scene(scene:Scene):
	var btn = TextureButton.new()
	btn.texture_normal = scene.load_texture()
	btn.connect("pressed", self, "_on_scene_pressed", [scene])
	btn.rect_scale = PE.TILE_SIZE/btn.texture_normal.get_size()
	btn.rect_position = cursor.snapped(PE.TILE_SIZE)
	foe_layer.add_child(btn)

func place_discovery():
	var place_i := rand.randi()%places.size()
	var place := places[place_i] as Scene
	place_scene(place)

func place_tile(pos:Vector2, to_place:Tile=random_tile()):
	if pos.snapped(PE.TILE_SIZE) in tile_map:
		print("already at " + str(pos.snapped(PE.TILE_SIZE)))
		return
	var tile = preload("res://Map/MapTile.tscn").instance()
	tile.tile = to_place
	tile_map[tile.place(pos.x, pos.y)] = tile
	tile.connect("clicked", self, "_on_tile_clicked")
	tiles_layer.add_child(tile)
	
	print("placed " + str(tile.rect_position))

func random_tile()->Tile:
	return possible_tiles[possible_tiles.keys()[randi()%possible_tiles.keys().size()]]

func move_player(pos:Vector2):
	pos = pos.snapped(PE.TILE_SIZE)
	player.position = pos
	tile_map[pos].visited = true

func _on_roll(outcome:String):
	cursor = last_tile_clicked.rect_position
	rations -= last_tile_clicked.tile.rations
	move_player(last_tile_clicked.rect_position)
	$HUD/Rations.text = str(rations)
	match outcome:
		"Nothing": pass
		"Discovery":
			$HUD/Talk.text = "You found something cool"
			place_discovery()
		"Encounter":
			$HUD/Talk.text = "Someone has seen you"
			place_foe()
	var pos = last_tile_clicked.rect_position
	if !tile_map.has(pos + RIGHT):
		place_tile(pos + RIGHT)
	if !tile_map.has(pos + LEFT):
		place_tile(pos + LEFT)
	if !tile_map.has(pos + UP):
		place_tile(pos + UP)
	if !tile_map.has(pos + DOWN):
		place_tile(pos + DOWN)

func _on_tile_clicked(tile:TextureButton):
	if tile.rect_position.distance_to(player.position) != PE.TILE_SIZE.x:
		ref_rect.editor_only = true
		rollbox.actions = []
		$HUD/Talk.text = "Choose a tile adjacent to you to move."
		return
	ref_rect.editor_only = false
	ref_rect.rect_position = tile.rect_position
	tile.select()
	var data := tile.tile as Tile
	rollbox.set_actions(data.load_outcomes())
	$HUD/Talk.text = "Roll to spend " + str(data.rations) + " rations to move into tile."
	$HUD/Talk.show()
	last_tile_clicked = tile
	
	
func _on_scene_pressed(scene:Scene):
	print(scene.title)
	var battle = load("res://Encounter/Encounter.tscn").instance()
	battle.foe = scene
	
	add_child(battle)
