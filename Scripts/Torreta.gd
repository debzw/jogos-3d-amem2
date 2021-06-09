extends StaticBody

onready var enemy = $"../../Navigation/EnemySpawner/Enemy"
onready var rof_timer = $ROF
onready var init_delay = $Initial_shoot_delay

export(PackedScene) var Bullet
export var bullet_speed = 60
export var shoot_delay = 100

var collision = false
var can_shoot = false
var closest_enemy 
var distance_enemy_to_player

var enemies_on_area = []
var minimum_distance = 500

func _ready():
	rof_timer.wait_time = shoot_delay / 1000.0
	init_delay.wait_time = 100/1000.0
	
func _on_enter(_body) :
	if (_body.is_in_group("enemy")):
		enemies_on_area.append(_body)
		collision = true
		init_delay.start()
		if enemies_on_area.size() == 1:
			enemy = enemies_on_area[0]
			#print("Somente 1 kra")
		#if enemies_on_area.size() > 1:
			#print("Mais de 1 kra")
			#reselect_target() #Detectar se um inimigo que acabou de chegar na área está mais proximo do que o antigo
			#mas somente funcionaria se a posição do inimigo fosse reiterada assim como na func _physics_process, uma
			#vez que a distância do inimigo entrando é sempre maior (raio)
			#init_delay.start()
	else:
		collision = false

func _on_leave(_body):#Se um inimigo sair do range da torreta, ou morrer
	enemies_on_area.erase(_body)
	if enemies_on_area.size() == 0:
		collision = false
		rof_timer.stop()
		can_shoot = false
	if enemies_on_area.size() > 0:
		reselect_target()
	
func reselect_target(): 
	for index in range (enemies_on_area.size()):	
		var turret_posit = Vector2 (global_transform.origin[0], global_transform.origin[2])
		var enemy_posit = Vector2 (enemy.global_transform.origin[0], enemy.global_transform.origin[2])
		distance_enemy_to_player = turret_posit - enemy_posit
		var hipotenuse = sqrt(pow(distance_enemy_to_player[0], 2) + pow(distance_enemy_to_player[1], 2))
		if hipotenuse < minimum_distance:
			minimum_distance = hipotenuse
			closest_enemy = index
	if enemies_on_area: #Doubleshooting quando o inimigo mais próximo já é o alvo
		enemy = enemies_on_area[closest_enemy]
		can_shoot = true
		collision = true	

func _physics_process(_delta): #Script para olhar para o inimigo
	if collision:
		var enemy_pos = Vector2 (enemy.global_transform.origin[0], enemy.global_transform.origin[2])
		var turret_pos = Vector2 (global_transform.origin[0], global_transform.origin[2])
		var angle = (rad2deg(enemy_pos.angle_to_point(turret_pos))) 
		rotation_degrees = Vector3(0, 180-angle, 0)
	if collision == false:
		if rotation_degrees[1] != 270:
			rotation_degrees[1] = 270

func _process(_delta):
	shoot()
	#(can_shoot)

func shoot(): 
	if can_shoot == true and enemies_on_area.size() != 0 :
		var new_bullet = Bullet.instance()
		new_bullet.global_transform = $Gun.global_transform
		new_bullet.speed = bullet_speed
		var scene_root = get_tree().get_root().get_children()[0]
		scene_root.add_child(new_bullet)
		can_shoot = false
		if enemies_on_area.size() != 0 :
			rof_timer.start() 
	elif enemies_on_area.size() == 0:
		rof_timer.stop() 
		can_shoot = false
		
func _on_Timer_timeout(): 
	#rof_timer.stop() 
	can_shoot = true

func _on_Initial_shoot_delay_timeout(): #Delaypara o primeiro tiro não ser disparado antes de a torreta olhar para o alvo
	if enemies_on_area.size() > 0:
		can_shoot = true
		init_delay.stop()
		#("delay over")
	if enemies_on_area.size() == 0:
		init_delay.stop()
		can_shoot = false
