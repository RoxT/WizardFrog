extends TextureButton

export(Resource) var tile_override
var tile:Tile

signal clicked(map_tile)

# Called when the node enters the scene tree for the first time.
func _ready():
	if tile_override != null: tile = tile_override
	texture_normal = tile.load_texture()
	hide_title()
	_unclick(null)


func place(x:float, y:float):
	rect_position = Vector2(x, y).snapped(PE.TILE_SIZE)
	
func show_title():
	$Label.text = str(tile.rations)
	$Label.show()
	
func hide_title():
	$Label.hide()
	
func _click():
	emit_signal("clicked", self)
	show_title()
	$ReferenceRect.show()
	get_tree().call_group("tile", "_unclick", self)

func _unclick(map_tile):
	if map_tile == null or map_tile != self:
		$ReferenceRect.hide()
		hide_title()


func _on_MapTile_pressed():
	_click()
