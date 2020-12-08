extends KinematicBody2D

var _gravity = preload("res://character/gravity.gd").new()

var _current_speed = 0
var _speed
var _max_speed = 4
var _last_acceleration = Vector2()
var _last_movement = Vector2()


func _ready():
	_setup_gravity()
	_setup_speed()


func _process(_delta):
	_handle_movement()
	_handle_gravity()
	_handle_animation()


func _physics_process(delta):
	_calculate_movement(delta)


func _calculate_movement(_delta):
	var move = _last_movement

	if move.x < 0:
		_turn_left()
	elif move.x > 0:
		_turn_right()

	if move == Vector2():
		_current_speed = 0
	else:
		_current_speed = _speed

	var acc = move * _current_speed

	_last_acceleration = acc
	_last_movement = Vector2()


func _turn_right():
	$AnimatedSprite.set_flip_h(true)


func _turn_left():
	$AnimatedSprite.set_flip_h(false)


func is_flipped():
	return $AnimatedSprite.flip_h

func move(move):
	_last_movement = move


func jump():
	if is_touching_floor():
		_gravity.jump()


func jump_cut():
	_gravity.jump_cut()


func is_touching_floor():
	return test_move(self.transform, Vector2(0, 1))


func _handle_movement():
	# warning-ignore:return_value_discarded
	move_and_slide(_last_acceleration, _gravity.FLOOR)


func _handle_gravity():
	_gravity.apply_gravity(self)


func _handle_animation():
	if is_touching_floor():
		if _is_moving():
			$AnimatedSprite.play('running')
		else:
			$AnimatedSprite.play('idle')
	else:
		if _gravity.is_falling():
			$AnimatedSprite.play('fall')
		else:
			$AnimatedSprite.play('jump')


func _setup_gravity():
	add_child(_gravity)
	_gravity.init(1.5, 0.5, 0.2)


func _setup_speed():
	_speed = _max_speed * _gravity.movement_unit


# returns true when reaches position
func move_to_position(target):
	var y_distance = abs(position.y -  target.y)
	var direction = position.direction_to(target)
	direction.y = 0

	if abs(direction.x) < 0.5 and y_distance < 10:
		return true
	else:
		move(direction)
		return false


func _is_moving():
	return _current_speed != 0


func get_jump_max_reach():
	return _gravity.get_jump_real_max_height() - 16

