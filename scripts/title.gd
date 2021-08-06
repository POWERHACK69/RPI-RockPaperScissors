extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	$AnimationPlayer.play("float")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	get_tree().change_scene("res://scenes/proto.tscn")


func _on_options_pressed():
	$Options.show()


func _on_quit_pressed():
	get_tree().quit()


func _on_Back_pressed():
	$Options.hide()
