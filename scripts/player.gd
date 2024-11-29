extends Node2D

const WALK_SPEED = 20
const RUN_SPEED = 40
const MOUNTED_WALK_SPEED = 80
const MOUNTED_RUN_SPEED = 120

# Node references
@onready var player_animated_sprite = $PlayerAnimatedSprite2D
@onready var horse = get_node("../Horse")

# Textures
@onready var player_mounted_texture = preload("res://images/PlayerMounted.png")
@onready var player_texture = preload("res://images/sprite_sheets/gaucho_walking/frame6.png")

# State variables
var current_speed = WALK_SPEED
var mounted = false
var horse_in_area = false

# Main game loop
func _process(delta):
	handle_interactions()
	handle_movement(delta)
	update_horse_position()

# Interaction logic
func handle_interactions():
	if Input.is_action_just_pressed("interact"):
		if horse_in_area and not mounted:
			mount_player()
		elif mounted:
			dismount_player()

# Movement logic
func handle_movement(delta):
	var is_moving = false
	# Determine speed based on state
	if mounted:
		current_speed = MOUNTED_RUN_SPEED if Input.is_action_pressed("ui_shift") else MOUNTED_WALK_SPEED
	else:
		current_speed = RUN_SPEED if Input.is_action_pressed("ui_shift") else WALK_SPEED

	# Move player
	if Input.is_action_pressed("move_right"):
		is_moving = true
		position.x += current_speed * delta
		handle_flip_h(mounted, "right")
	elif Input.is_action_pressed("move_left"):
		position.x -= current_speed * delta
		handle_flip_h(mounted, "left")
		is_moving = true
		
	if is_moving:
		if player_animated_sprite.animation != "walk":
			player_animated_sprite.play("walk")
	else:
		if player_animated_sprite.animation != "idle":
			player_animated_sprite.play("idle")
			
func handle_flip_h(mounted, direction):
	player_animated_sprite.flip_h = (direction == "right") if mounted else (direction == "left")

func update_horse_position():
	if mounted:
		horse.position = position  # Align horse's position with the player's position

# Area signals
func _on_player_area_2d_area_entered(body):
	if body.name == "HorseArea2D":
		horse_in_area = true

func _on_player_area_2d_area_exited(body):
	if body.name == "HorseArea2D":
		horse_in_area = false

# Mounting logic
func mount_player():
	mounted = true
	horse.visible = false
	#player_animated_sprite.texture = player_mounted_texture

func dismount_player():
	mounted = false
	horse.visible = true
	#player_sprite.texture = player_texture
