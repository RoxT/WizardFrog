class_name Mob
extends Resource
export(int) var hp=1
var max_hp := 1
export(Resource) var abl
export(String) var temperment=""
var scene:Scene setget set_template

# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(what_am_i:Scene):
	max_hp = 1
	temperment = ""
	abl = Abl.new()
	set_template(what_am_i)
	
func set_template(value:Scene):
	scene = value
	if value != null:
		max_hp = scene.hp
		hp = max_hp
		abl = Abl.new(scene)
		
func rolls()->Array:
	return scene.dmg

func title()->String:
	return scene.title

func skill(skill:String)->int:
	assert(skill in ["str_", "wil", "dex"])
	return scene.get(skill)

func load_texture()->Texture:
	return scene.load_texture()

	
