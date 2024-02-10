class_name Mob
extends Resource
export(String) var temperment=""

export(Resource) var scene = Scene.new() setget set_template
export(Resource) var combat


# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(what_am_i:Scene=Scene.new(), new_combat=null):
	temperment = ""
	combat=new_combat
	set_template(what_am_i)
	
func set_template(value:Scene):
	scene = value
	if value != null and scene.hp > 0:
		var abl = Abl.new()
		abl.scene(scene)
		combat = Combat.new(scene.hp, 0, scene.dmg, abl)
		
func rolls()->Array:
	return combat.dmg

func title()->String:
	return scene.title

func has_combat()->bool:
	return combat != null

func skill(skill:String)->int:
	assert(skill in ["str_", "wil", "dex"])
	return combat.get(skill)

func load_texture()->Texture:
	return scene.load_texture()

	
