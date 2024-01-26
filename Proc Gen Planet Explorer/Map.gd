extends Control

onready var tiles_layer := $TilesLayer
onready var foe_layer := $FoesLayer
onready var center := get_rect().get_center()
onready var UP := Vector2.UP * PE.TILE_SIZE
onready var DOWN := Vector2.DOWN * PE.TILE_SIZE
onready var RIGHT := Vector2.RIGHT * PE.TILE_SIZE
onready var LEFT := Vector2.LEFT * PE.TILE_SIZE
var foes := []
var possible_tiles := {}
var cursor:Vector2
var rand := RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	rand.randomize()
	foes = PE.get_all_foes()
		
	possible_tiles = PE.get_all_tiles()
	cursor = center
	for _i in range(20):
		place_rand_tile()
		cursor += [UP, DOWN, LEFT, RIGHT][rand.randi()%4]
		place_rand_tile()
		cursor += [UP, DOWN, LEFT, RIGHT][rand.randi()%4]
		place_rand_tile()
		cursor += [UP, DOWN, LEFT, RIGHT][rand.randi()%4]
		place_rand_tile()

func place_foe():
	var foe_i := rand.randi()%foes.size()
	var foe := foes[foe_i] as Scene
	var btn = TextureButton.new()
	btn.texture_normal = foe.load_texture()
	btn.connect("pressed", self, "_on_foe_pressed", [foe_i])
	btn.rect_scale = PE.TILE_SIZE/btn.texture_normal.get_size()
	btn.rect_position = cursor.snapped(PE.TILE_SIZE)
	foe_layer.add_child(btn)

func place_rand_tile():
	var tile = preload("res://Map/MapTile.tscn").instance()
	tile.tile = possible_tiles[possible_tiles.keys()[randi()%possible_tiles.keys().size()]]
	tile.place(cursor.x, cursor.y)
	tiles_layer.add_child(tile)
	print("placed " + str(tile.rect_position))
	if rand.randi_range(0, 6) > 4:
		place_foe()

func _on_foe_pressed(index:int):
	print(foes[index].title)
	var battle = load("res://Battle/Battle.tscn").instance()
	battle.foe = foes[index]
	add_child(battle)
