extends CanvasLayer


var multipier_value = 1
var base_cost = 100
@onready var update_button = preload("res://Objects/update_button.tscn")
var up = 0
@onready var scroller= $Control/Scroller
@onready var button_parrent = $Control/Scroller/MarginContainer/VBoxContainer

@onready var autoclicker_node = preload("res://Objects/auto_clicker.tscn")
@onready var autoclicker_parent = get_parent().get_parent().get_node(NodePath("AutoClickers"))

func _ready() -> void:
	scroller.get_v_scroll_bar().modulate = Color(0, 0, 0, 0)
	set_auto_clicker()
	
	
	for m in $Control/HBoxContainer.get_children():
		m.connect("pressed",Callable(self,"update_multipier").bind(m))
		pass
	set_updates_buttons()
	update_buttons()
	
	
	


func update_buttons():
	for i in Globals.grave_update_data.keys():
		var current_price = calculate_price(i)
		var current_button = button_parrent.get_node(NodePath(i))
		var current_button_node = current_button.get_node(NodePath("Button"))
		current_button_node.text = "Price:" + str(GameMath.format_number(current_price)) + "\n" + "Level UP^" + "\n" + "x UPG"
		current_button.get_node(NodePath("Description")).text = "Name: "+ i + "\n" + "Lv: " + str(Globals.grave_update_data[i][1]) + "\n" + "Data: " +Globals.grave_update_data[i][0]
		#break
	pass


func update_multipier(button):
	#print("m button pressed: ", button.button_pressed)
	var m_value  = str(button.name)
	m_value[0] = ""
	multipier_value = int(m_value)
	#disable other m_button
	for m_b in $Control/HBoxContainer.get_children():
		if m_b.name != button.name:
			m_b.button_pressed = false
	#print(m_value)
	update_buttons()

func set_updates_buttons():
	for i in Globals.grave_update_data.keys():
		var new_update_button = update_button.instantiate()
		button_parrent.add_child(new_update_button)
		new_update_button.name = i
		new_update_button.position = $Control/Scroller/MarginContainer/VBoxContainer.position
		var n_button_node = new_update_button.get_node(NodePath("Button"))
		n_button_node.connect("pressed",Callable(self,"Button_pressed").bind(new_update_button.name))
		#var update_price = GameMath.upgrade_cost(1,Globals.grave_update_data[i][1])
		
		#var current_price
		#if multipier_value != 1:
		#	current_price = GameMath.upgrade_cost_multi(Globals.grave_update_data[i][2],Globals.grave_update_data[i][1],multipier_value)
		#else:
		#	current_price = GameMath.upgrade_cost(Globals.grave_update_data[i][2],Globals.grave_update_data[i][1])
		
		
		#n_button_node.text = "Price:" + str(GameMath.format_number(current_price)) + "\n" + "Level UP^" + "\n" + "x UPG"
		#new_update_button.get_node(NodePath("Description")).text = "Name: "+ i + "\n" + "Lv: " + str(Globals.grave_update_data[i][1]) + "\n" + "Data: " +Globals.grave_update_data[i][0]

func Button_pressed(button_index):

	#if button_index == "0":
	var current_price = calculate_price(button_index)
	print(current_price)
	
	if Globals.bones >= round(current_price):
		Globals.bones -= round(current_price)
		Globals.grave_update_data[button_index][1] += multipier_value
		#Globals.grave_update_data[button_index][2] += float(multipier_value)
		update_buttons()
		if button_index != "update_1":
			if Globals.grave_update_data[button_index][4] == "deactive":
				Globals.grave_update_data[button_index][4] == "active"
				autoclicker_parent.get_node(NodePath(button_index)).start()

		
		#scroller.get_node(NodePath("MarginContainer/VBoxContainer")).get_children()[int(button_index)].text = "Price:" + str(GameMath.format_number(current_price))+"\n"+"Level Up"
		#scroller.get_node(NodePath("MarginContainer/VBoxContainer")).get_children()[int(button_index)].get_node(NodePath("LevelLabel")).text = "Level: "+str(Globals.grave_update_data["tap_level"])

func calculate_price(button_index):
	var current_price = 0
	if multipier_value != 1:
		current_price = GameMath.upgrade_cost_multi(Globals.grave_update_data[button_index][2],Globals.grave_update_data[button_index][1],multipier_value)
	else:
		current_price = GameMath.upgrade_cost(Globals.grave_update_data[button_index][2],Globals.grave_update_data[button_index][1])
	#print("CP: ",current_price)
	return current_price



func update_exist_buttons():
	for i in button_parrent.get_children():
		pass




@onready var enemy_pos = get_parent().get_node(NodePath("EnemyBase")).global_position

"""
var ac_positions = {
	"update_2": Vector3(enemy_pos.x-64,enemy_pos.y-64,enemy_pos.z),
	"update_3": Vector3(enemy_pos.x+64,enemy_pos.y-64,enemy_pos.z+64),
	"update_4": Vector3(enemy_pos.x+64,enemy_pos.y-64,enemy_pos.z),
}
"""


func set_auto_clicker():
	var ac_positions = {
	"update_2": Vector3(enemy_pos.x-1,enemy_pos.y+0.5,enemy_pos.z),
	"update_3": Vector3(enemy_pos.x+1,enemy_pos.y-0.5,enemy_pos.z),
	"update_4": Vector3(enemy_pos.x+1,enemy_pos.y+0.5,enemy_pos.z),
	}
	
	for i in Globals.grave_update_data.keys():
		if i != "update_1":
			var new_ac = autoclicker_node.instantiate()
			autoclicker_parent.add_child(new_ac)
			new_ac.name = i
			new_ac.global_position = ac_positions[i]
			new_ac.update_visual()
			new_ac.cooldown = Globals.grave_update_data[i][3]
			new_ac.connect("hit",Callable(self,"hit_enemy").bind(i))
			
		
func hit_enemy(name):
	var attack_power =GameMath.tap_income(Globals.grave_update_data[name][2],Globals.grave_update_data[name][1])
	print(name, "-Attack_power: ",attack_power)
	
	get_parent().get_node(NodePath("EnemyBase")).hit(attack_power)
	pass
		
		
		
	
	pass


#all screen setting must will change witc viewport rect
func _on_up_pressed() -> void:
	if up == 0:
		$Control.position.y =$Control.position.y/2
		up+=1
		$Control.size.y = 576
	elif up == 1:
		$Control.position.y = 0
		up +=1
		$Control/ColorRect/down.show()
		$Control/ColorRect/up.disabled = true
		$Control/ColorRect/down.disabled = false
		$Control.size.y = 1152
	pass # Replace with function body.


func _on_down_pressed() -> void:
	if up == 2:
		$Control.position.y = 1152
		$Control.size.y = 576
		$Control/ColorRect/down.disabled =true
		$Control/ColorRect/down.hide()
		$Control/ColorRect/up.disabled = false
		up = 0
		
		
		
