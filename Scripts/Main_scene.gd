extends Spatial

class_name Worldd

onready var ray = $Selection_UI/RayCast
onready var map = $Navigation/NavigationMeshInstance2/Map
onready var camera = $CameraUI/CameraUI2/Camera
onready var selection_cube = $Selection_UI/MeshInstance
onready var build_button = $Botoes/Build_mode_button
onready var button_wave = $Botoes/ButtonWave
onready var money_text = $Botoes/Money_text
onready var buttonmenu = $Botoes/Menu

var menu = preload("res://Scenes/PopupMenu.tscn")
var torreta = preload("res://Scenes/Torreta.tscn")
var artilharia = preload("res://Scenes/Artilharia.tscn")

var in_menu = false
var can_build = false
var mouse_pos 
var point
var selection_position
var ray_length = 2000

var collision_area = false
var build_menu = true
var money = 100

export(Color, RGB) var blue
export(Color, RGB) var red

signal _on_world_attack_fase

#UI de posicionar defesas
func _physics_process(_delta):
	UIBuild()
	if Input.is_action_just_pressed("Esc"):
		if buttonmenu.visible == false:
			buttonmenu.visible = true
		else:
			buttonmenu.visible = false
			
func UIBuild():
	if build_menu == true:
		if !in_menu:
			selection_cube.visible = true
			#Pegar posicão relativa do mouse 
			mouse_pos = get_viewport().get_mouse_position()
			var from = get_viewport().get_camera().project_ray_origin(mouse_pos)
			#var from = camera.project_position(mouse_pos)
			var to = get_viewport().get_camera().project_ray_normal(mouse_pos) * ray_length
			#var to = from * camera.project_ray_normal(mouse_pos) * ray_lenght

			ray.transform.origin = from 
			#ray.translation = from
			ray.cast_to = to
			ray.force_raycast_update()
			#collision point translated into gridmap coordinate
			point = map.world_to_map(ray.get_collision_point())
			var tile = map.get_cell_item(point.x, point.y, point.z)
			
			#Definir cor e disponibilidade da tile
			if tile == -1 and point.x > -10 and point.x < 10 and point.z > -10 and point.z < 10:
				selection_cube.get_surface_material(0).set_shader_param("current_color", blue)
				can_build = true
				#if point.x > -11 and point.x < 11 and point.y > -11 and point.y < 11:
				#print(point)
			else:
				selection_cube.get_surface_material(0).set_shader_param("current_color", red)
				can_build = false
			#Move Selection box
			selection_position = map.map_to_world(point.x, point.y, point.z)
			selection_cube.translation = selection_position
			
		if Input.is_action_just_pressed("Right_click") and can_build:
			if !in_menu:
				in_menu = true
				var m = menu.instance()
				m.rect_position = mouse_pos
				$Interface.add_child(m)
			else:
				clear_menu_container()
				in_menu = false


# Contrução de defesas
func _build_torreta(ID):
	match ID:
		0:
			if money >= 30:
				money -=30
				money_text.text = str(money)
				var tower = torreta.instance()
				tower.translation = selection_position
				$Container.add_child(tower)
		#1:
			#if money >= 50 :
			#	money -=50
			#	money_text.text = str(money)
			#	var tower = artilharia.instance()
			#	tower.translation = selection_position
			#	$Container.add_child(tower)

	clear_menu_container()
		
	map.set_cell_item(point.x, point.y, point.z, 15)
	in_menu = false

#Limpar a caixa de menu
func clear_menu_container():
	for child in $Interface. get_child_count():
		$Interface.get_child(0).queue_free()









#Testes e outras bobeiras
#func _on_mouse_enter(area: Area):
	#if area.is_in_group("area_build"):
		#collision_area = true
		#print ("entrou")

#func _on_area_exited(area: Area):
#	if area.is_in_group("area_build"):
		#collision_area = false
		#print ("saiu")





#func _on_Artilharia_pressed() -> void:
	#pass # Replace with function body.


func _on_CheckButton_pressed() -> void:
	pass # Replace with function body.


func _on_ButtonWave_pressed():
	selection_cube.visible = false
	build_menu = false
	emit_signal("_on_world_attack_fase")
	button_wave.visible = false





func _on_Menu_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/MenuPrincipal.tscn")
