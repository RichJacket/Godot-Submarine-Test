extends AIController3D

@onready var raycast_sensor := $RayCastSensor3D

var rotate_action : Vector3
var move_action : Vector3

func _physics_process(_delta):
	n_steps += 1
	# A time-out for the player
	if n_steps > reset_after:
		_player.game_over(-5)

func get_obs() -> Dictionary:
	# Get the raycast data & player position, velocity & rotation
	var obs: Array[float] = []
	obs.append_array(raycast_sensor.get_observation())
	var player_position = _player.global_position
	var player_velocity = _player.velocity
	var player_angle = _player.transform.basis.get_euler()
	obs.append_array([
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

## Resets the AIController (e.g. when game is over)
func reset():
	super.reset()

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
