class_name Place
extends Encounterable
export(String) var scene_title = "Unknown"

# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init():
	pass

func apply_scene(scene:Scene):
	scene_title = scene.title
	title = scene_title
	texture_location = scene.texture
