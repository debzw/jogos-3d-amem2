extends StaticBody

var vida_base = 100
onready var enemy = $"../Navigation/EnemySpawner/Enemy"
onready var nav = $"../Navigation"
onready var timer = $Timer

func _process(delta):
	pass
	if vida_base == 0:
		get_tree().change_scene("res://Scenes/MenuPrincipal.tscn")

func _on_enter(_body):
		
	if (_body.is_in_group("enemy")):
		if vida_base > 10:
			vida_base -= 10
		if vida_base <= 10:
			vida_base = 0
		#print (vida_base)
		
		#enemy.dead()
		
		#timer.connect("timeout", _body, "queue_free")
		#timer.set_wait_time(0.3)
		#timer.start()
		#_body.queue_free()
		#get_node("enemy").free()

		
	

	#if enemy.slide_count > 0 :
	#	for count in range (enemy.slide_count):
	#		var collision = enemy.get_slide_collision(count)
	#		var collider = collision.enemy.collider
			
	#		if collider.is_in_group("enemy"):
	#		#name() == "Base":
	#			print ("foi")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Range_body_entered(body: Node) -> void:
	pass # Replace with function body.
