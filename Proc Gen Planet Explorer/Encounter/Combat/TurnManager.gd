extends VFlowContainer

const PLAYER_LEAF:PackedScene = preload("res://Player/CharacterLeaf.tscn")
const SCENE_LEAF:PackedScene = preload("res://Encounter/Combat/CombatantLeaf.tscn")
export(Array) var combatants = [] setget set_combatants

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_combatants(value:Array):
	combatants = value
	var children := []
	for c in combatants:
		children.append(_leaf(c))
	children.sort_custom(Combat, "initiative")
	for l in children:
		add_child(l)
	
func _leaf(combatant)->Panel:
	var l
	if combatant is Player:
		l = PLAYER_LEAF.instance()
		l.player = combatant
	elif combatant is Scene:
		l = SCENE_LEAF.instance()
		l.scene = combatant
	else:
		push_error("combatant must be player or scene")
	return l

func find_name(l)->String:
	var i = 1
	var title = l.scene.title
	if get_node_or_null(title) == null:
		return title
	else:
		var temp = title + str(i)
		while(get_node_or_null(title) != null):
			i += 1
			temp = title + str(i)
		return temp
