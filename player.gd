extends CharacterBody3D

@onready var ai_controller = $AIController3D

@export var max_speed = 3
@export var rotation_speed = 3

var current_speed = 0
var angular_velocity : Quaternion
var linear_velocity = Vector3.ZERO

func _ready():
	ai_controller.init(self)

func game_over():
	ai_controller.done = true
	ai_controller.needs_reset = true

func _physics_process(delta):
	if ai_controller.needs_reset:
		ai_controller.reset()
		return
	#Rotate player
	var pitch = 0
	var yaw = 0
	var roll = 0
	if ai_controller.heuristic == "human":
		if Input.is_action_pressed("pitchUp"):
			pitch += rotation_speed
		if Input.is_action_pressed("pitchDown"):
			pitch -= rotation_speed
		if Input.is_action_pressed("yawLeft"):
			yaw += rotation_speed
		if Input.is_action_pressed("yawRight"):
			yaw -= rotation_speed
		if Input.is_action_pressed("rollLeft"):
			roll -= rotation_speed
		if Input.is_action_pressed("rollRight"):
			roll += rotation_speed
	else:
		pitch = ai_controller.rotate_action.x * rotation_speed
		yaw = ai_controller.rotate_action.z * rotation_speed
		roll = ai_controller.rotate_action.y * rotation_speed
	
	
	var rotation_vector = Vector3(deg_to_rad(roll), deg_to_rad(yaw), deg_to_rad(pitch)) * delta
	var relative_velocity = Quaternion.from_euler(rotation_vector)
	angular_velocity = (angular_velocity * relative_velocity).slerp(Quaternion.IDENTITY, 0.1)
	
	var current_rotation = Quaternion(transform.basis)
	var pre_final_rotation = current_rotation * angular_velocity
	var euler_angles = pre_final_rotation.get_euler()
	var final_rotation = pre_final_rotation.slerp(Quaternion.from_euler(Vector3(0, euler_angles.y, 0)), 0.005)
	transform.basis = Basis(final_rotation)
	
	transform = transform.orthonormalized()
	
	pitch = 0
	yaw = 0
	
	#Move player
	var linear_direction = Vector3.ZERO
	if ai_controller.heuristic == "human":
		if Input.is_action_pressed("accelerateForward"):
			linear_direction.x += 1
		if Input.is_action_pressed("accelerateBackward"):
			linear_direction.x -= 1
		if Input.is_action_pressed("accelerateLeft"):
			linear_direction.z -= 1
		if Input.is_action_pressed("accelerateRight"):
			linear_direction.z += 1
		if Input.is_action_pressed("accelerateUp"):
			linear_direction.y += 1
		if Input.is_action_pressed("accelerateDown"):
			linear_direction.y -= 1
	else:
		linear_direction.x = ai_controller.move_action.x
		linear_direction.z = ai_controller.move_action.z
		linear_direction.y = ai_controller.move_action.y
	
	if linear_direction != Vector3.ZERO:
		linear_direction = linear_direction.normalized()
	linear_velocity = final_rotation * linear_direction
	
	velocity = velocity.move_toward(linear_velocity * max_speed, 0.1)
	move_and_slide()
	
#func _on_area_3d_body_entered(body):
#	ai_controller.reward += 1.0
