extends Node2D

var speed = 20
var boost_multiplier = 2

func _process(delta):
	var current_speed = speed
	if Input.is_action_pressed("ui_shift"):
		current_speed *= boost_multiplier

	if Input.is_action_pressed("move_right"):
		position.x += current_speed * delta
	elif Input.is_action_pressed("move_left"):
		position.x -= current_speed * delta
