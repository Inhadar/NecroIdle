extends Node3D


@export var cooldown : float  = 1.0
#var hit_value = 0.0
signal hit



var autoclicker_types = {
	"update_2":TorusMesh.new(),
	"update_3":SphereMesh.new(),
	"update_4":PrismMesh.new(),
}

func update_visual() -> void:
	%MeshInstance3D.mesh = autoclicker_types[name]


func start():
	$Timer.wait_time = cooldown
	$Timer.start()

func stop():
	$Timer.stop()

func _on_timer_timeout() -> void:
	hit.emit()
