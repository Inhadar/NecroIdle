extends Control


@onready var maps_buttons = $MapsButton.get_children()

func _ready() -> void:
	check_maps()
	


func set_label(value):
	$Bones.text = "Bone:"+"\n" + GameMath.format_number(value)
	#$Souls.text = "Soul: " + GameMath.format_number(value[1])

func check_maps():
	for i in maps_buttons:
		for j in i.get_children():
			j.connect("pressed",Callable(self,"Map_button_pressed").bind(j.name))
		
		
			if j.name in Globals.unlocked_maps[i.name]:
				j.show()
			else:
				j.hide()
			



func Map_button_pressed(name):
	if get_tree().current_scene.name != name:
		get_tree().change_scene_to_file("res://Scenes/3D/"+name+".tscn")
	
		print(name)
