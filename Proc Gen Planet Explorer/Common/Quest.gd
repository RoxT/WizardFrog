class_name Quest
extends Resource
export(int) var health
export(Vector2) var location
export(Vector2) var giver #Should be saved encounter or location????


# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(new_health = 0):
	health = new_health
