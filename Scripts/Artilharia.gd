extends Spatial

onready var camera = $"../../CameraUI/Camera"
onready var ray = $"../../Selection_UI/RayCast"
onready var map = $"../../Navigation/Map"
onready var button = $"../../Botoes/Artilharia"
onready var selection_cube = $"../../Selection_UI/ArtilhariaShoot"

var ray_origin = Vector3()
var ray_end = Vector3()
var ray_target = Vector3()
var can_build = true
var mouse_pos 
var point
var selection_position
var ray_length = 2000

var artilharia_aim = false

export(Color, RGB) var blue
export(Color, RGB) var red



func _input(event):
	if event is InputEventMouseMotion:
		ray_origin = camera.project_ray_origin(get_viewport().get_mouse_position())
		ray_target = camera.project_ray_normal(get_viewport().get_mouse_position())*ray_length

func _physics_process(delta):
	if button.artilharia_aim == true:
		var space_state = get_world().direct_space_state
		var ray1 = space_state.intersect_ray(ray_origin,ray_target,[self],1,true,true)
		if ray1:
			var ray1_collision_point = ray1.position
			var object_position = get_translation()
			ray1_collision_point = object_position-ray1_collision_point
			var angle = Vector2(ray1_collision_point.x,ray1_collision_point.z).angle_to(Vector2(object_position.x, object_position.z))
			self.set_rotation(Vector3(0,angle,0))
			#(angle)
		
		selection_cube.visible = true
		mouse_pos = get_viewport().get_mouse_position()
		var from = get_viewport().get_camera().project_ray_origin(mouse_pos)
		var to = get_viewport().get_camera().project_ray_normal(mouse_pos) * ray_length
		ray.transform.origin = from 
		ray.cast_to = to
		ray.force_raycast_update()
		#collision point translated into gridmap coordinate
		point = map.world_to_map(ray.get_collision_point())
		var tile = map.get_cell_item(point.x, point.y, point.z)
		
		if tile == -1:
			selection_cube.get_surface_material(0).set_shader_param("current_color", blue)
			
		else:
			selection_cube.get_surface_material(0).set_shader_param("current_color", red)
			
		selection_position = map.map_to_world(point.x, point.y, point.z)
		selection_cube.translation = selection_position
	

#func _on_CheckButton_pressed():
	#if artilharia_aim == false:
		#artilharia_aim = true
	#else:
		#artilharia_aim = false
	
	#var space_state = get_world().get_mouse_position()
	#mouse_pos = get_viewport().get_mouse_position()
	
	#ray_origin = camera.project_ray_origin(mouse_pos)
	#ray_end = ray_origin * camera.project_ray_normal(mouse_pos) * 2000
	#var intersection = space_state.intersect_ray(ray_origin, ray_end)
	
	#if not intersection.empty():
	#var pos = intersection.position
	#$Rig.look_at(Vector3(pos.x, translation. y, pos.z), Vector3(0,1,0))
	#print ("empty")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

#func physics_process(delta):
	#var space_state = get_world().get_mouse_position()
	#var mouse_pos = get_viewport().get_mouse_position()
	
	#var self_pos = Vector2 (global_transform.origin[0], global_transform.origin[2])
	#var angle = (rad2deg(mouse_pos.angle_to_point(self_pos))) 
	#rotation_degrees = Vector3(0, 180-angle, 0)
	
	
	#ray_origin = camera.project_ray_origin(mouse_pos)
	#ray_end = ray_origin * camera.project_ray_normal(mouse_pos) * 2000
	#var intersection = space_state.intersect_ray(ray_origin, ray_end)
	
	#if not intersection.empty():
		#var pos = intersection.position
		#$Rig.look_at(Vector3(pos.x, translation. y, pos.z), Vector3(0,1,0))
		#print ("empty")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass"


 

