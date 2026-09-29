extends Node3D
var base_tap = 1

func _ready() -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():

		var current_tap_damage =  GameMath.tap_income(Globals.grave_update_data["update_1"][2],Globals.grave_update_data["update_1"][1])
		
		
		#Globals.coin += current_tap_income
		$RootCanvas/EnemyBase.hit(current_tap_damage)


		
func _process(delta: float) -> void:
	#$SubViewportContainer/SubViewport/UI.set_coin(GameMath.format_number(Globals.coin))
	$RootCanvas/UI.set_label(Globals.bones)
	pass
