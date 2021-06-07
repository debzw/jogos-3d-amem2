extends CheckButton

var artilharia_aim = false
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

func _on_Artilharia_pressed():
	if artilharia_aim == false:
		artilharia_aim = true
	else:
		artilharia_aim = false
		
func _ready() -> void:
	pass # Replace with function body.


