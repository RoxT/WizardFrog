extends Label

const NEW_STYLEBOX:StyleBoxFlat = preload("res://Common/Scenes/new_styleboxflat.tres")

signal highlight_finished

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func highlight():
	add_stylebox_override("normal", NEW_STYLEBOX)

func un_highlight():
	remove_stylebox_override("normal")

func animate_highlight():
	$AnimationPlayer.play("highlight")

func _on_AnimationPlayer_animation_finished(_anim_name):
	emit_signal("highlight_finished")
