extends Control


@onready var forgevisual = %SlaveMesh

@export var roll_speed = 100.0

var selected_slave = "slave4" 


func set_slave_visual(value):#0 <- is no change
	var slave_types = Globals.slaves.keys()
	if value == 0:
		%SlaveMesh.mesh = Globals.slaves[selected_slave][3]
		pass
	else:
		var current_slave_index = (slave_types.find(selected_slave)+value+slave_types.size()) %slave_types.size()
		selected_slave = slave_types[current_slave_index]
		%SlaveMesh.mesh = Globals.slaves[selected_slave][3]
	print("Curren_selected_Slave: ",selected_slave)
	if Globals.slaves[selected_slave][4] == true:
		$ForgeButton.disabled = false
		#change mesh color
	else:
		$ForgeButton.disabled = true
		#change mesh color

func forge_new_slave():
	if Globals.slaves[selected_slave][4] == true:
		Globals.slaves[selected_slave][0] +=1

	pass
	
	
	 
func _ready() -> void:
	set_slave_visual(0)



func _physics_process(delta: float) -> void:
	pass
"""
	if %SlaveMesh.rotation_degrees.y <360.0:
		%SlaveMesh.rotation_degrees.y += roll_speed*delta
	else:
		var dif = %SlaveMesh.rotation_degrees.y -360.0
		%SlaveMesh.rotation_degrees.y = 0.0+dif
"""


func _on_forge_button_pressed() -> void:
	pass # Replace with function body.


func _on_left_pressed() -> void:
	set_slave_visual(-1)


func _on_right_pressed() -> void:
	set_slave_visual(1)
