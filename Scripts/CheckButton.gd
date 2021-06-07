extends CheckButton

var build_menu = false
	


#Botao que ativa o modo construcao 
func _on_Build_mode_button_pressed():
	if build_menu == false:
		build_menu = true
	else:
		build_menu = false
 

#the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


#func _button_down():
	#build_menu = true
	#print ("true")


#func _button_up():
	#build_menu = false
	#print("false")








