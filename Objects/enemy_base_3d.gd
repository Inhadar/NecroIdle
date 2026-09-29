extends StaticBody3D

var max_health = 100.0
var health = 100.0
signal change_enemy
var resource_value = {"bones":3,"souls":1}

var base_income_resources = [3,1]

var enemy_level_data_pack = {
	"grave":{
		0:[Color(1.0, 1.0, 1.0)],
		1:[Color(0.0, 0.839, 0.118)],
		2:[Color(0.282, 0.353, 1.0)],
		3:[Color(1.0, 0.353, 0.38)],
		4:[Color(1.0, 1.0, 0.38)],
		5:[Color(0.558, 0.002, 0.813)],
	}
}


var current_grave_level = 0

func _ready() -> void:
	current_grave_level = Globals.calculate_grave_level()
	
	health = roundf(GameMath.enemy_healt(max_health,current_grave_level))
	%ProgressBar.max_value = health
	%ProgressBar.value = health
	$SubViewport/ProgressBar/Label.text = GameMath.format_number(health)
	 
	$AnimationPlayer.play("Damping")
	var bone = GameMath.tap_income(base_income_resources[0],Globals.graves_level)
	var soul = GameMath.tap_income(base_income_resources[1],Globals.graves_level)

func hit(value):
	health -=value
	%ProgressBar.value -=value
	$SubViewport/ProgressBar/Label.text = GameMath.format_number(health)
	if health <=0:
		print("datas: ",max_health,"/",current_grave_level+1)
		
		health = roundf(GameMath.enemy_healt(max_health,current_grave_level))
		%ProgressBar.max_value = health
		%ProgressBar.value = health
		$SubViewport/ProgressBar/Label.text = GameMath.format_number(health)
		print(GameMath.defeat_income(health))
		Globals.bones += GameMath.defeat_income(health)
		#Globals.necro_resources[0] += GameMath.defeat_income(health)[0]#<-Bones
		#Globals.necro_resources[1] += GameMath.defeat_income(health)[1]#<-Souls
		#<defeat animation trigger is here
		#when defeat anim is finished emit next enemy the signal
		Globals.digged_graves += 1
		next_enemy()
		
	else:
		pass

func set_next_enemy(enemy_level):
	var h = $MeshInstance3D.get_surface_override_material(0)
	print(enemy_level)
	h.albedo_color= enemy_level_data_pack["grave"][randi()%enemy_level_data_pack["grave"].size()][0]
	
	
func next_enemy():
	print("next enemy is ready")
	
	health = roundf(GameMath.enemy_healt(max_health,current_grave_level))
	%ProgressBar.max_value = health
	%ProgressBar.value = health
	$SubViewport/ProgressBar/Label.text = GameMath.format_number(health)
	
	Globals.calculate_grave_level()
	current_grave_level = Globals.calculate_grave_level()
	set_next_enemy(Globals.graves_level)
	pass
