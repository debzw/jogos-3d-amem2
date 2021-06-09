extends KinematicBody

class_name Enemy

onready var nav = $"../../"
onready var go_to = $"../../../Base" 
onready var timer = $Timer
onready var spawner = $"../"
onready var world = $"../../../"

var path = []
var current_node = 0
var has_path = true
var rand = RandomNumberGenerator.new()
var is_alive = true
var x = 0
var new_direction
var distance_z
var distance_x
var base_pos 
var enemy_pos

onready var enemy_speed = 2 + ( 1 * world.torreta_quant) 
export var life = 80

signal enemy_death_signal



#Pegar o path
func _ready():
	enemy_pos = Vector2 (self.global_transform.origin[0], self.global_transform.origin[2])
	#print(enemy_pos)
	path = nav.get_simple_path(global_transform.origin, go_to.global_transform.origin)  
	var delay  = rand.randf_range(2.0, 3.0)
	timer.set_wait_time(delay)
	timer.start()
	
#sumir ao cdar dano da torre central
func dead():
	if is_alive == true:
		is_alive = false 
		$AnimationPlayer.play("Explosion")
		yield($AnimationPlayer, "animation_finished")
		emit_signal("enemy_death_signal")
		queue_free()
		#("dead")

#Seguir o path de ready
func _physics_process(_delta):
	if has_path == true:
		enemy_has_path()
	if has_path == false:
		random_path()

func _on_enter(_body):
	if (_body.is_in_group("Base")):
		self.dead()

func _on_Area_area_entered(area: Area):
	if (area.is_in_group("Bullet")):
		if (life >= 20):
			life -= 20
		else:
			life = 0
		if life == 0:
			self.dead()
			spawner.enemy_killed += 1 


func random_path():
	base_pos = Vector2 (go_to.global_transform.origin[0], go_to.global_transform.origin[2])
	enemy_pos = Vector2 (self.global_transform.origin[0], self.global_transform.origin[2])
	var angle = int(rad2deg(enemy_pos.angle_to_point(base_pos))) 
	#print(angle)
	x += 1
	if x == 1:
		if (-45< angle and angle <45) or (angle >315):
			rand.randomize()			
			distance_z  = rand.randi_range(1, -1)
			while distance_z == 0:
				distance_z  = rand.randi_range(1, -1)
			new_direction = Vector3 (0, 0, distance_z)
		if (45< angle and angle <135) or (-315< angle and angle <-225):
			rand.randomize()
			distance_x  = rand.randi_range(1, -1)
			while distance_x == 0:
				distance_x  = rand.randi_range(1, -1)
			new_direction = Vector3 (distance_x, 0, 0)
		if (135< angle and angle<225) or (-225< angle and angle <-135):
			rand.randomize()
			distance_z  = rand.randi_range(1, -1)
			while distance_z == 0:
				distance_z  = rand.randi_range(1, -1)
			new_direction = Vector3 (0, 0, distance_z)
		if (225< angle and angle <315) or (-135< angle and angle <-45 ):
			rand.randomize()
			distance_x  = rand.randi_range(1, -1)
			while distance_x == 0:
				distance_x  = rand.randi_range(1, -1)
			new_direction = Vector3 (distance_x, 0, 0)
	# warning-ignore:return_value_discarded
	move_and_slide(new_direction.normalized()*enemy_speed)
		
		
	
func enemy_has_path():
	x = 0
	if current_node< path.size() and has_path == true:
		var direction = (path[current_node] - global_transform.origin)
		if direction.length() < 1:
			current_node += 1
		else:
			# warning-ignore:return_value_discarded
			move_and_slide(direction.normalized()*enemy_speed)
	
func new_path():
	path = nav.get_simple_path(global_transform.origin, go_to.global_transform.origin)
	
func _on_Timer_timeout():
	var delay
	if has_path == true:
		has_path = false
		rand.randomize()
		delay  = rand.randf_range(1.0, 2.0)
	elif has_path == false:
		has_path = true
		rand.randomize()
		delay  = rand.randf_range(4.0, 6.0)
	timer.set_wait_time(delay)
	timer.start()





#if slide_count > 0 :
		#for count in range (slide_count):
		#	var collision = get_slide_collision(count)
		#	var collider = collision.collider
		#	
		#	if collider.name() == "Base":
		#	#is_in_group("enemy"):
		#	#name() == "Base":
		#		print ("foi")"

