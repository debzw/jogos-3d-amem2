extends Spatial


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _process(_delta):
	if Input.is_action_pressed("Right_D"):
		if rotation_degrees[1]< 360:
			rotation_degrees[1] += 1
		else:
			rotation_degrees[1] = 0
	if Input.is_action_pressed("Left_A"):
		if rotation_degrees[1]< 360:
			rotation_degrees[1] -= 1
		else:
			rotation_degrees[1] = 0
