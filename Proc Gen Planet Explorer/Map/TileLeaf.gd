extends Panel

const VISIT := "Tap Go or Visit to spend %s rations to move into tile."
const GO := "Tap Go to spend %s rations to move into tile."
const EXPLORE := "Tap tile again or 'Roll' to roll for encounter and spend %s rations to move into tile."
export(Resource) var tile setget set_tile

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_tile(value:Tile):
	tile = value
	if tile == null:
		hide()
	else:
		show()
		$Title.text = tile.title
		$Cost.text = str(tile.rations) + " Rations"
		if tile.visited:
			if tile.can_visit():
				_desc(VISIT)
			else:
				_desc(GO)
		else:
			_desc(EXPLORE)
			
func _desc(text:String):
	$Desc.text = text % tile.rations
