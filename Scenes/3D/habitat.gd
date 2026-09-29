extends Node3D

@onready var slave_base = preload("res://Objects/slave_base.tscn")

@export var speed: float = 5.0
@export var ray_length: float = 1.2
@export var gravity = 100.0 

var direction = Vector3.FORWARD  # ilk yön


func _ready():
	add_slaves()



func add_slaves():
	for i in Globals.slaves.keys():
		for j in Globals.slaves[i][0]:
			var new_slave = slave_base.instantiate()
			new_slave.set_slave_mesh(Globals.slaves[i][3])
			$RootCanvas/Node3D2/SubViewportContainer/SubViewport/Slave_container.add_child(new_slave)
			new_slave.global_position = Vector3(randf_range(1,-1),1,randf_range(1,-1))
			new_slave.scale = Vector3(0.2,0.2,0.2)
			new_slave.type = i
	
var lerp_speed = 10.0
func  _physics_process(delta: float) -> void:
	

	
	if grabbed_object:
		print("A")
		grabbed_object.position.x = lerp(grabbed_object.position.x,get_grab_position().x,delta*lerp_speed)
		grabbed_object.position.z = lerp(grabbed_object.position.z,get_grab_position().y,delta*lerp_speed)
		
		


########_MOUSE_INTEGRATION_#########
var mouse_ = Vector2()
var grabbed_object = null
#var grab_position = Vector3()
var grabbing = false
#var Zpos = 1000

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_ = event.position
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			get_mouse_world_pos()
		elif event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
			if grabbed_object:
				if grabbed_object.ready_to_merge:
					grabbed_object.start_merge()
				grabbed_object.im_grabing = false
				grabbed_object = null

func get_mouse_world_pos():
	
	#pick test2#
	var camera = $RootCanvas/Node3D2/SubViewportContainer/SubViewport/Camera3D
	var mouse_pos = get_viewport().get_mouse_position()
	
	var rayStart :Vector3 = camera.project_ray_origin(mouse_pos)
	var dir = camera.project_ray_normal(mouse_pos)
	var space = get_world_3d().direct_space_state
	var p:PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(rayStart,rayStart+dir*100.0)
	var result := space.intersect_ray(p)
		
	if result.is_empty() == false:
		if result.collider.is_in_group("Slave"):
			grabbed_object = result.collider
			grabbed_object.im_grabing = true
			#grab_position = result.position
			print(result)
	
	#pick test1#
	"""
	var space = get_world_3d().direct_space_state
	var start = get_viewport().get_camera_3d().project_ray_origin(mouse)
	var end = get_viewport().get_camera_3d().project_position(mouse,DIST)
	var params = PhysicsRayQueryParameters3D.new()
	
	params.from = start
	params.to = end
	
	var result = space.intersect_ray(params)
	
	if result.is_empty() == false:
		if result.collider.is_in_group("Slave"):
			grabbed_object = result.collider
	print(result)
	"""
func get_grab_position():
	#pick test2#
	var camera = $RootCanvas/Node3D2/SubViewportContainer/SubViewport/Camera3D
	var mouse_pos = get_viewport().get_mouse_position()+Vector2(0,0.4)
	
	
	var rayStart :Vector3 = camera.project_ray_origin(mouse_pos)
	var dir = camera.project_ray_normal(mouse_pos)
	var plane := Plane(Vector3.UP)
	var instersection = plane.intersects_ray(rayStart,dir)
	var result = Vector2(instersection.x,instersection.z)
	return result 
	
