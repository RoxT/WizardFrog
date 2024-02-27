extends VFlowContainer

const PLAYER_LEAF:PackedScene = preload("res://Player/CharacterLeaf.tscn")
const SCENE_LEAF:PackedScene = preload("res://Encounter/Combat/FoeLeaf.tscn")

export(Array) var combatants = [] setget set_combatants
export(Array, Resource) var scene_focus_override

var turn := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if combatants.size() == 0 and scene_focus_override.size() > 0:
		var list := []
		for o in scene_focus_override:
			if o is Scene:
				var foe = Creature.new()
				foe.apply_scene(o)
				list.append(foe)
			else:
				list.append(PE.new_random_player_creature(o))
		set_combatants(list)

func set_combatants(value:Array):
	combatants = value
	combatants.sort_custom(Creature, "initiative")
	var children := []
	for c in combatants:
		children.append(_leaf(c))
	for l in children:
		add_child(l)
		
func roll_dmg()->int:
	return get_children()[turn].roll_dmg()
		
func current()->Creature:
	return get_children()[turn].creature
	
func is_player_turn()->bool:
	return get_children()[turn].creature.is_player()

func do_turn():
	turn = (turn+1)&combatants.size()
	
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

