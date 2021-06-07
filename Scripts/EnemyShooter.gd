extends KinematicBody

class_name EnemyShooter

onready var nav = $"../../"
onready var go_to = $"../../../Base" 
onready var timer = $Timer
onready var spawner = $"../"
onready var rof_timer = $ROF

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
var can_shoot = false

export var enemy_speed = 5
export var life = 100
export var bullet_speed = 7
export var shoot_delay = 1000
signal enemy_death_signal

export(PackedScene) var BulletEnemy


func _ready():
	enemy_pos = Vector2 (self.global_transform.origin[0], self.global_transform.origin[2])
	print(enemy_pos)
	path = nav.get_simple_path(global_transform.origin, go_to.global_transform.origin)  
	var delay  = rand.randf_range(2.0, 3.0)
	timer.set_wait_time(delay)
	timer.start()
	rof_timer.wait_time = shoot_delay / 1000.0
	rof_timer.start()

func dead():
	if is_alive == true:
		is_alive = false
		$AnimationPlayer.play("Explosion")
		yield($AnimationPlayer, "animation_finished")
		emit_signal("enemy_death_signal")
		queue_free()

func _physics_process(delta):
	if has_path == true:
		enemy_has_path()
	if has_path == false:
		random_path()
	shoot()
	_rotation()

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
	move_and_slide(new_direction.normalized()*enemy_speed)
		
func enemy_has_path():
	x = 0
	if current_node< path.size() and has_path == true:
		var direction = (path[current_node] - global_transform.origin)
		if direction.length() < 1:
			current_node += 1
		else:
			move_and_slide(direction.normalized()*enemy_speed)
	
func new_path():
	path = nav.get_simple_path(global_transform.origin, go_to.global_transform.origin)
	
func _on_Timer_timeout():
	if has_path == true:
		has_path = false
	elif has_path == false:
		has_path = true
	rand.randomize()
	var delay  = rand.randf_range(2.0, 3.0)
	timer.set_wait_time(delay)
	timer.start()

func shoot(): 
	if can_shoot == true:
		var new_bullet = BulletEnemy.instance()
		new_bullet.global_transform = $Gun.global_transform
		new_bullet.speed = bullet_speed
		var scene_root = get_tree().get_root().get_children()[0]
		scene_root.add_child(new_bullet)
		can_shoot = false
		rof_timer.start()

func _on_ROF_timeout():
	can_shoot = true

func _rotation():
	rotation_degrees[1] += 3
