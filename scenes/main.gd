extends Node2D


func _process(_delta):
	var motion = Vector2()
	if (Input.is_action_pressed("ui_left")):
		motion += Vector2(-1, 0)

	if (Input.is_action_pressed("ui_right")):
		motion += Vector2(1, 0)

	$player.move(motion)

	_handle_follower()


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

	if (event.is_action_pressed("jump")):
		$player.jump()

	if (event.is_action_released("jump")):
		$player.jump_cut()


func _handle_follower():
	if $follower.position.distance_to($player.position) < 24:
		return

	if $follower/sensors.is_facing_edge() or $follower/sensors.is_facing_jumpable_blocker():
		$follower.jump()

	$follower.go_to_direction($follower.position.direction_to($player.position))

