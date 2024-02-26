extends VFlowContainer

const PLAYER_LEAF:PackedScene = preload("res://Player/CharacterLeaf.tscn")
const SCENE_LEAF:PackedScene = preload("res://Encounter/Combat/FoeLeaf.tscn")
export(Array) var combatants = [] setget set_combatants

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_combatants(value:Array):
	combatants = value
	var children := []
	for c in combatants:
		children.append(_leaf(c))
	for l in children:
		add_child(l)
	
func _leaf(creature:Creature)->Panel:
	var l
	if creature.is_player():
		l = PLAYER_LEAF.instance()
	else:
		l = SCENE_LEAF.instance()
	l.creature = creature
	return l

func find_name(l)->String:
	var i = 1
	var title = l.creature.title
	if get_node_or_null(title) == null:
		return title
	else:
		var temp = title + str(i)
		while(get_node_or_null(title) != null):
			i += 1
			temp = title + str(i)
		return temp
