extends Node


onready var _character = get_parent()

onready var _blocker_detection_direction = $lower_ray.cast_to.x
onready var _edge_detection_position = $edge_detection_ray.position.x


var _sensors_flipped = false

func _process(_delta):
	if _sensors_flipped == _character.is_flipped():
		return

	_sensors_flipped = _character.is_flipped()

	if _sensors_flipped:
		_turn_right()
	else:
		_turn_left()


func _turn_right():
	$lower_ray.cast_to.x = _blocker_detection_direction * -1
	$upper_ray.cast_to.x = _blocker_detection_direction * -1
	$edge_detection_ray.position.x = _edge_detection_position * -1


func _turn_left():
	$lower_ray.cast_to.x = _blocker_detection_direction
	$upper_ray.cast_to.x = _blocker_detection_direction
	$edge_detection_ray.position.x = _edge_detection_position


func is_facing_jumpable_blocker():
	return $lower_ray.is_colliding() and not $upper_ray.is_colliding()


func is_facing_impossible_blocker():
	return $lower_ray.is_colliding() and $upper_ray.is_colliding()


func is_facing_edge():
		return not $edge_detection_ray.is_colliding()

