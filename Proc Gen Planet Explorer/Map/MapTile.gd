extends TextureButton

export(Resource) var tile_override
var tile:Tile
var mob:Encounterable setget set_mob

# To Save
var visited := false
var hostile := false

signal clicked(map_tile)

# Called when the node enters the scene tree for the first time.
func _ready():
	visit(visited)
	if tile == null: tile = tile_override
	texture_normal = tile.load_texture()
	set_mob(mob)

func set_mob(value:Encounterable):
	mob = value
	if mob == null:
		$SceneTex.hide()
	else:
		$SceneTex.show()
		var tex:Texture = mob.load_texture()
		$SceneTex.texture = tex
		$SceneTex.rect_scale = PE.TILE_SIZE/tex.get_size()

func snapped(cursor:Vector2)->Vector2:
	return cursor.snapped(PE.TILE_SIZE)

func place(x:float, y:float)->Vector2:
	rect_position = Vector2(x, y).snapped(PE.TILE_SIZE)
	return rect_position
	
func visit(value=true):
	visited = value
	if value:
		$AnimationPlayer.play("Visited")
	else:
		$AnimationPlayer.play("Fog")
	
func _click():
	emit_signal("clicked", self)
	get_tree().call_group("tile", "_unclick", self)

func select(frame:ReferenceRect):
	frame.move(rect_position, tile.rations)


func _on_MapTile_pressed():
	_click()
