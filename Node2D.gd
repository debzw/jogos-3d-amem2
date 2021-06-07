extends Node2D


func _process(delta):
	if Input.is_action_just_pressed("Left_click"):
		get_tree().change_scene("res://Scenes/MenuPrincipal.tscn")
