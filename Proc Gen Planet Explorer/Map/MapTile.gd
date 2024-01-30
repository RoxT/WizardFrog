extends TextureButton

export(Resource) var tile_override
var tile:Tile

# To Save
var visited := false

signal clicked(map_tile)

# Called when the node enters the scene tree for the first time.
func _ready():
	if tile == null: tile = tile_override
	texture_normal = tile.load_texture()
	hide_title()
	_unclick(null)

func snapped(cursor:Vector2)->Vector2:
	return cursor.snapped(PE.TILE_SIZE)

func place(x:float, y:float)->Vector2:
	rect_position = Vector2(x, y).snapped(PE.TILE_SIZE)
	return rect_position
	
func show_title():
	$Label.text = str(tile.rations)
	$Label.show()
	
func hide_title():
	$Label.hide()
	
func _click():
	emit_signal("clicked", self)
	get_tree().call_group("tile", "_unclick", self)

func select():
	show_title()
	

func _unclick(map_tile):
	if map_tile == null or map_tile != self:
		hide_title()


func _on_MapTile_pressed():
	_click()
