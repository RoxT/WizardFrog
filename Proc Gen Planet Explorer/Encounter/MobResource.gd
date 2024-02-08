class_name Mob
extends Resource
export(int) var hp=1
var max_hp := 1
export(String) var template_title=""
export(String) var temperment=""
var scene:Scene

# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(new_template_title=""):
	max_hp = 1
	temperment = ""
	set_template_title(new_template_title)
	
func set_template_title(value:String):
	template_title = value
	if !value.empty():
		scene = load(Scene.SCENES_FOLDER + "value" + ".tres") as Scene
		max_hp = scene.hp
		hp = max_hp
		
func rolls()->Array:
	return scene.dmg

func load_texture()->Texture:
	return scene.load_texture()

	
