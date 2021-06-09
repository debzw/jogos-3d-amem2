extends Node

onready var world = $"../../../../"

var enemy_addition 
var spawn_delay 
var enemy_thoughness
var previous_enemy_count = 0
var current_enemy_count =0

var rand = RandomNumberGenerator.new()


func _rand_wave():
	rand.randomize()
	enemy_addition = round(rand.randf_range(0, 1) * world.torreta_quant + 0.001)
	current_enemy_count = previous_enemy_count + enemy_addition
	previous_enemy_count = current_enemy_count
	
	rand.randomize()
	var x = rand.randf_range(400, 600) 
	rand.randomize()
	var y = rand.randf_range(200, 300) 
	spawn_delay = (x/y)

	
	
	
