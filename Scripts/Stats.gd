extends Node

export var max_HP = 10

var current_HP = max_HP

func _ready():
	pass 
	
func take_hit(damage):
	current_HP -= 1
	#("Hit", current_HP, "/", max_HP)
	
	if current_HP <= 0:
		die()
		
func die():
	queue_free()
