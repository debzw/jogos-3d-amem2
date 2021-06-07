extends KinematicBody

class_name Enemy

onready var nav = $"../../"
onready var go_to = $"../../../Base" 
onready var timer = $Timer
onready var spawner = $"../"

var path = []
var current_node = 0
var has_path = true
var rand = RandomNumberGenerator.new()
var is_alive = true

export var enemy_speed = 5
export var life = 60


signal enemy_death_signal

#Pegar o path
func _ready():
	path = nav.get_simple_path(global_transform.origin, go_to.global_transform.origin)  
	
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
func _physics_process(delta):
	if current_node< path.size() and has_path == true:
		var direction = (path[current_node] - global_transform.origin)
		if direction.length() < 1:
			current_node += 1
		else:
			move_and_slide(direction.normalized()*enemy_speed)

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


func random_follow():
	while true:
		rand.randomize()
		var delay  = rand.randf_range(1.0, 5.0)
		timer.set_wait_time(delay)
		has_path = false
		rand.randomize()
		var distance_x  = rand.randf_range(4.0, -4.0)
		rand.randomize()
		var distance_z  = rand.randf_range(4.0, -4.0)
		var new_x = global_transform.origin[0] + distance_x
		var new_direction = global_transform.origin
		
		
	
func new_path():
	path = nav.get_simple_path(global_transform.origin, go_to.global_transform.origin)
	






#if slide_count > 0 :
		#for count in range (slide_count):
		#	var collision = get_slide_collision(count)
		#	var collider = collision.collider
		#	
		#	if collider.name() == "Base":
		#	#is_in_group("enemy"):
		#	#name() == "Base":
		#		print ("foi")"

