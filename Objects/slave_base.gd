extends CharacterBody3D

@export var speed: float = 5.0
@export var ray_length: float = 1.2
@export var gravity = 100.0 

var direction = Vector3.FORWARD  # ilk yön
var im_grabing = false
var type = "slave1"


func _ready():
	randomize()
	_pick_random_direction()

func _physics_process(delta):
	if im_grabing == false:
		
		# Kenar kontrolü: aşağıya doğru raycast
		if not _ground_ahead():
			# kenar varsa yönü değiştir
			direction = -direction
		else:
			# ara sıra rastgele yön değişimi
			if randi() % 100 == 0:
				_pick_random_direction()

		velocity = direction * speed *delta
		velocity.y -= gravity*delta
		move_and_slide()


func _ground_ahead() -> bool:
	var from = global_transform.origin
	var forward_pos = from + direction * 0.2
	var to = forward_pos + Vector3.DOWN * ray_length

	var space = get_world_3d().direct_space_state
	var result = space.intersect_ray(PhysicsRayQueryParameters3D.create(forward_pos, to))
	
	return result.size() > 0  # yere çarpıyorsa true

func _pick_random_direction():
	# sadece sağ-sol (x ekseni) rastgele yön seç
	var x = randf_range(-1.0, 1.0)
	var z = randf_range(-1.0, 1.0)
	direction = Vector3(x, 0, z).normalized()


func  set_slave_mesh(slave_mesh):
	$MeshInstance3D.mesh = slave_mesh


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Slave"):
		print("contact_to:", body.type)
		if type == body.type:
			if body.is_merging == false and im_grabing:
				if Globals.slaves[type][5]  != "n/a":
					is_merging = true
					ready_to_merge = true
					couple_node = body
					

			pass


@onready var slave = preload("res://Objects/slave_base.tscn")

var is_merging = false
var ready_to_merge = false
var couple_node =null
func start_merge():
	var new_slave = slave.instantiate()
	new_slave.type = Globals.slaves[type][5]
	get_parent().add_child(new_slave)
	new_slave.global_position = Vector3(randf_range(1,-1),1,randf_range(1,-1))
	new_slave.scale = Vector3(0.2,0.2,0.2)
	new_slave.set_slave_mesh(Globals.slaves[new_slave.type][3])
	new_slave.position = couple_node.position
	queue_free()
	couple_node.queue_free()  
	pass
