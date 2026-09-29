extends Node
var base_tap = 10

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():

		var current_tap_income =  GameMath.tap_income(base_tap,Globals.upgrade_level_datas["tap_level"])
		
		
		#Globals.coin += current_tap_income
		$EnemyBase.hit(current_tap_income)


		
func _process(delta: float) -> void:
	$UI.set_coin(GameMath.format_number(Globals.coin))
