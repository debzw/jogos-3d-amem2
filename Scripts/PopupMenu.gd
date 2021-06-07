extends PopupMenu


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true
	connect("id_pressed", get_parent().get_parent(), "_build_torreta")
