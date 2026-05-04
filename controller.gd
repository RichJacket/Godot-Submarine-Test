extends AIController3D

# Stores the actions sampled for the agent's policy, running in python
var rotate_action : Vector3
var move_action : Vector3

func get_obs() -> Dictionary:
	# get the balls position and velocity in the paddle's frame of reference
	var player_position = _player.global_position
	var player_velocity = _player.velocity
	var player_angle = _player.transform.basis.get_euler()
	var obs = [
		player_position.x,
		player_position.z,
		player_position.y,
		player_velocity.x,
		player_velocity.z,
		player_velocity.y,
		player_angle.x,
		player_angle.z,
		player_angle.y,
	]

	return {"obs":obs}

func get_reward() -> float:	
	return reward
	
func get_action_space() -> Dictionary:
	return {
		"rotate_action" : {
			"size": 3,
			"action_type": "continuous"
		},
		"move_action" : {
			"size": 3,
			"action_type": "continuous"
		},
		}
	
func set_action(action) -> void:	
	rotate_action.x = clamp(action["move_action"][0], -1.0, 1.0)
	rotate_action.z = clamp(action["move_action"][1], -1.0, 1.0)
	rotate_action.y = clamp(action["move_action"][2], -1.0, 1.0)
	move_action.x = clamp(action["move_action"][0], -1.0, 1.0)
	move_action.z = clamp(action["move_action"][1], -1.0, 1.0)
	move_action.y = clamp(action["move_action"][2], -1.0, 1.0)
