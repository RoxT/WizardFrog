class_name Encounterable
extends Resource
export(String) var title := "Unknown"
export(String) var temper = "Nothing"
export(String) var texture_location = "Player/Sword.jpg"

# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init():
	pass

func load_texture()->Texture:
	return load("res://" + texture_location) as Texture
