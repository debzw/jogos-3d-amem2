extends Node

onready var timer = $Timer
onready var waves_node = $Waves
onready var world = $"../../"
onready var button_wave = $"../../Botoes/ButtonWave"
onready var turn = $"../../Botoes/Turn"

var enemies_not_spawned
var enemies_killed_this_wave

var waves
var current_wave_num = 0
var random_side 
var x
var z

onready var random_wave = $"Waves/Random_wave"
var enemy_killed = 0

func _ready():
	waves = $Waves.get_children()
	connect_to_attack_fase_signals(world)

func connect_to_enemy_signals(enemy: Enemy):
	# warning-ignore:return_value_discarded
	enemy.connect("enemy_death_signal", self, "_on_Enemy_enemy_death_signal")
	
# warning-ignore:return_value_discarded
func connect_to_attack_fase_signals(_Worldd):
	# warning-ignore:return_value_discarded
	world.connect("_on_world_attack_fase", self, "_on_world_attack_fase")
	

func _on_Enemy_enemy_death_signal():
	enemies_killed_this_wave += 1
	
func _random_wave_generator():
	waves_node.add_child(random_wave)
	
func start_wave():
	random_wave._rand_wave()
	enemies_killed_this_wave = 0
	current_wave_num += 1
	turn.text = str(current_wave_num)
	enemies_not_spawned = random_wave.current_enemy_count
	timer.wait_time = random_wave.spawn_delay
	timer.start()
	
func _on_Timer_timeout():
	if enemies_not_spawned > 0:
		var rand = RandomNumberGenerator.new()
		var enemyscene = load("res://Scenes/Enemy.tscn")
		var enemy = enemyscene.instance()
		rand.randomize()
		random_side = rand.randi_range(1, 4)
		if random_side == 1:
			x = -37
			rand.randomize()
			z  = rand.randf_range(-26, 26)
		if random_side == 2:
			x = 37
			rand.randomize()
			z  = rand.randf_range(-26, 26)
		if random_side == 3:
			z = -37
			rand.randomize()
			x  = rand.randf_range(-26, 26)
		if random_side == 4:
			z = 37
			rand.randomize()
			x = rand.randf_range(-26, 26)

		enemy.transform.origin[0] = x
		enemy.transform.origin[2] = z
		enemy.transform.origin[1] = 0 
		add_child(enemy)
		enemies_not_spawned -= 1
		
		connect_to_enemy_signals(enemy)
	else:
		if enemies_killed_this_wave == random_wave.current_enemy_count:
			world.money += enemy_killed * 10
			world.money_text.text = str(world.money)
			enemy_killed = 0
			world.build_menu = true#Change to construction mode
			button_wave.visible = true
	

func _on_world_attack_fase():
	#("attak")
	start_wave()
	
