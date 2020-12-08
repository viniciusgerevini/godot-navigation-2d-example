extends Node

const FLOOR = Vector2(0, -1)
var gravity_movement = Vector2()

var movement_unit = 32
var gravity_multiplier = 1
var jump_max_height = 1.5
var jump_min_height = 0.5
var jump_duration = 0.3
var gravity

var jump_strength
var jump_min_strength

func init(max_height = 1.5, min_height = 0.5, duration = 0.3):
	jump_max_height = max_height
	jump_min_height = min_height
	jump_duration = duration
	setup_gravity()


func _physics_process(delta):
	calculate_gravity(delta)


func calculate_gravity(delta):
	gravity_movement.x = 0
	gravity_movement.y += gravity * delta


func apply_gravity(object):
	gravity_movement = object.move_and_slide(gravity_movement, FLOOR, true)


func setup_gravity():
	var max_height = jump_max_height * movement_unit
	var min_height = jump_min_height * movement_unit

	gravity = gravity_multiplier * max_height / pow(jump_duration, 2)
	jump_strength = sqrt(2 * gravity * max_height)
	jump_min_strength = sqrt(2 * gravity * min_height)


func jump():
	gravity_movement.y = -jump_strength


func jump_cut():
	if gravity_movement.y < -jump_min_strength:
		gravity_movement.y = -jump_min_strength


func is_falling():
	return gravity_movement.y > 0


func get_jump_real_max_height():
	return jump_max_height * movement_unit


