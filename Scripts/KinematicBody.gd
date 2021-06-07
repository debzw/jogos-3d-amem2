extends KinematicBody

var path = []
var current_node = 0
var enemy_speed = 5
onready var nav = get_parent()
onready var go_to = $"../../Base"

var slide_count = get_slide_count()

func _ready():
	path = nav.get_simple_path(global_transform.origin, go_to.global_transform.origin)
	
func _physics_process(delta):
	if current_node< path.size():
		var direction = (path[current_node] - global_transform.origin)
		if direction.length() < 1:
			current_node += 1
		else:
			move_and_slide(direction.normalized()*enemy_speed)


func _on_Range_body_entered(body):
	pass # Replace with function body.
