extends AIController3D

@onready var raycast_sensor := $RayCastSensor3D
@onready var goal = $/root/Main/Goal

var rotate_action : Vector3
var move_action : Vector3
var is_success := false

func get_info() -> Dictionary:
	if done: 
		return {"is_success": is_success}
	return {}

#Get observation space data (raycast data; player position, velocity, rotation)
func get_obs() -> Dictionary:
	var obs: Array[float] = []
	#obs.append_array(raycast_sensor.get_observation())
	var player_position = _player.global_position
	var player_velocity = _player.velocity
	var player_angle = _player.transform.basis.get_euler()
	var goal_position = _player.to_local(goal.global_position)
	obs.append_array([
		goal_position.x,
		goal_position.z,
		goal_position.y,
		player_position.x,
		player_position.z,
		player_position.y,
		player_velocity.x,
		player_velocity.z,
		player_velocity.y,
		player_angle.x,
		player_angle.z,
		player_angle.y,
	])
	return {"obs":obs}

func get_reward() -> float:	
	return reward

#Reset the AIController (e.g. when game is over)
func reset():
	super.reset()

#Get action space (movement actions)
func get_action_space() -> Dictionary:
	return {
		"rotate_action" : {
			"size": 2,
			"action_type": "continuous"
		},
		"move_action" : {
			"size": 1,
			"action_type": "continuous"
		},
		}

#Complete chosen action (apply movement)
func set_action(action) -> void:	
	rotate_action.x = clamp(action["rotate_action"][0], -1.0, 1.0)
	rotate_action.z = clamp(action["rotate_action"][1], -1.0, 1.0)
	#rotate_action.y = clamp(action["rotate_action"][2], -1.0, 1.0)
	move_action.x = clamp(action["move_action"][0], -1.0, 1.0)
	#move_action.z = clamp(action["move_action"][1], -1.0, 1.0)
	#move_action.y = clamp(action["move_action"][1], -1.0, 1.0) #Change index to 2 for 6DOF
