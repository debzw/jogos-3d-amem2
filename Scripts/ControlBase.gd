extends Control

onready var base = $"../"
onready var life_bar = $lifebar
onready var max_width = 490

func _ready() -> void:
	pass # Replace with function body.


func _process(delta):
	life_bar.rect_size.x = int((base.vida_base * max_width)/100)
	
