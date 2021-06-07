extends Spatial

export var speed = 70
export var kill_time = 2


var timer = 0

func _physics_process(delta):
	var forward_direction = global_transform.basis.z.normalized()
	global_translate(forward_direction * speed * delta)

	timer += delta
	if timer >= kill_time:
		queue_free()


func _on_Area_area_entered(area: Area):
	if (area.is_in_group("Enemy")):
		queue_free()
