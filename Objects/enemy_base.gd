extends StaticBody2D

var health = 100
signal change_enemy
var resource_value = {"bones":3,"souls":1}

func hit(value):
	health -=value
	%ProgressBar.value = health
	if health <=0:
		print("grave is digged")
		#<defeat animation trigger is here
		#when defeat anim is finished emit next enemy the signal
		change_enemy.emit()
		
	else:
		pass


func next_enemy(enemy_level):
	print("next enemy is ready")
	health =100#<-this will be change idle values
	pass
