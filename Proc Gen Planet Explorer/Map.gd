extends Control

const MAPTILE:PackedScene = preload("res://Map/MapTile.tscn")
const BATTLE_SCENE:PackedScene = preload("res://Encounter/Encounter.tscn")
onready var tiles_layer := $TilesLayer
onready var foe_layer := $FoesLayer
onready var hud := $HUD
onready var rollbox = hud.rollbox
onready var player := $UI/Player
onready var frame := $UI/Frame
onready var center := get_rect().get_center().snapped(PE.TILE_SIZE)
onready var UP:Vector2 = Vector2.UP * PE.TILE_SIZE
onready var DOWN:Vector2 = Vector2.DOWN * PE.TILE_SIZE
onready var RIGHT:Vector2 = Vector2.RIGHT * PE.TILE_SIZE
onready var LEFT:Vector2 = Vector2.LEFT * PE.TILE_SIZE
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
	err(rollbox.connect("rolled", self, "_on_roll"))
	err(frame.connect("frame_pressed", self, "_on_frame_pressed"))
	frame.rect_position = player.position
	print("----------------")
	
func err(err:int):
	if err != OK:
		push_warning("Error connecting:" + str(err))

func place_foe(tile:Control):
	var foe_i := rand.randi()%foes.size()
	var mob := Mob.new(foes[foe_i] as Scene)
	tile.set_mob(mob)
	_on_scene_pressed(mob)

func place_discovery(tile:Control):
	var place_i := rand.randi()%places.size()
	var mob := Mob.new(places[place_i] as Scene)
	tile.set_mob(mob)
	_on_scene_pressed(mob)

func place_tile(pos:Vector2, to_place:Tile=random_tile()):
	if pos.snapped(PE.TILE_SIZE) in tile_map:
		print("already at " + str(pos.snapped(PE.TILE_SIZE)))
		return
	var tile = MAPTILE.instance()
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
	tile_map[pos].visit()

func _on_frame_pressed():
	rollbox._on_Roll_pressed()

func _on_roll(outcome:String):
	var battle = get_node_or_null("Encounter")
	if battle != null:
		battle._on_Next_pressed(outcome)
		return

	if last_tile_clicked.visited:
		_move_into_last_clicked()
		if last_tile_clicked.hostile:
			_on_scene_pressed(last_tile_clicked.mob)
		return
		
	_move_into_last_clicked()
	match outcome:
		"Nothing": pass
		"Discovery":
			$HUD/Talk.text = "You found something cool"
			place_discovery(last_tile_clicked)
		"Encounter":
			$HUD/Talk.text = "Someone has seen you"
			place_foe(last_tile_clicked)
	var pos = last_tile_clicked.rect_position
	if !tile_map.has(pos + RIGHT):
		place_tile(pos + RIGHT)
	if !tile_map.has(pos + LEFT):
		place_tile(pos + LEFT)
	if !tile_map.has(pos + UP):
		place_tile(pos + UP)
	if !tile_map.has(pos + DOWN):
		place_tile(pos + DOWN)
		
func _move_into_last_clicked():
	cursor = last_tile_clicked.rect_position
	rations -= last_tile_clicked.tile.rations
	move_player(last_tile_clicked.rect_position)
	last_tile_clicked.visited = true
	$UI/Rations.text = str(rations)
		
func _on_Next_pressed(option:String):
	var battle = get_node_or_null("Encounter")
	if battle != null:
		battle._on_Next_pressed(option)
	else:
		match option:
			"Visit": 
				_move_into_last_clicked()
				_on_scene_pressed(last_tile_clicked.mob)

func _on_tile_clicked(tile:TextureButton):
	
	hud.next.destroy_options()
	hud.rollbox.set_no_roll()
	rand.randomize()
	if tile.rect_position.distance_to(player.position) != PE.TILE_SIZE.x:
		rollbox.actions = []
		$HUD/Talk.text = "Choose a tile adjacent to you to move."
		frame.hide()
		return
	tile.select(frame)
	var data := tile.tile as Tile
	last_tile_clicked = tile
	
	if tile.visited:
		if tile.mob == null or tile.hostile:
			$HUD/Talk.text = "Tap Go to spend " + str(data.rations) + " rations to move into tile."
			hud.just_go()
		else:
			$HUD/Talk.text = "Tap Go or Visit to spend " + str(data.rations) + " rations to move into tile."
			hud.next.connect_options(self, ["Visit"])
			hud.just_go()
	else:
		rollbox.set_actions(data.load_outcomes())
		$HUD/Talk.text = "Tap tile again or 'Roll' to roll for encounter and spend " + str(data.rations) + " rations to move into tile."
	$HUD/Talk.show()
	
func _on_scene_pressed(mob:Mob):
	print(mob.title())
	var battle = BATTLE_SCENE.instance()
	battle.hud = hud
	battle.tile = last_tile_clicked
	add_child(battle)
