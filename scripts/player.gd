extends Node2D

const WALK_SPEED = 20
const RUN_SPEED = 30
const MOUNTED_WALK_SPEED = 40
const MOUNTED_RUN_SPEED = 60

# Node references
@onready var player_animated_sprite = $PlayerAnimatedSprite2D
@onready var player_mounted_animated_sprite = $PlayerMountedAnimatedSprite2D

@onready var horse = get_node("../Horse")

# Textures
@onready var player_mounted_texture = preload("res://images/PlayerMounted.png")
@onready var player_idle_texture = preload("res://images/sprite_sheets/gaucho_walking/frame6.png")

# Footsteps
@onready var footstep_audio = $FootstepAudioStreamPlayer2D
@onready var footstep_timer = $FootstepTimer

# State variables
var current_speed = WALK_SPEED
var mounted = false
var horse_in_area = false

var footstep_sounds = [
	preload("res://audio/player/footstep1.ogg"),
	preload("res://audio/player/footstep2.ogg"),
]

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
		is_moving = true
		position.x -= current_speed * delta
		handle_flip_h(mounted, "left")
		
	if is_moving:
		if mounted:
			player_mounted_animated_sprite.play("mounted_walk")
		else: 
			player_animated_sprite.play("walk")
			
		if footstep_timer.is_stopped():
			footstep_audio.stream = footstep_sounds[randi() % footstep_sounds.size()]
			footstep_audio.play()
			footstep_timer.start(0.8)
	else:
		if mounted:
			player_mounted_animated_sprite.play("mounted_idle")
		else: 
			player_animated_sprite.play("idle")
			
func handle_flip_h(mounted, direction):
	if mounted:
		player_mounted_animated_sprite.flip_h = (direction == "right") if mounted else (direction == "left")
	else:
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
	player_animated_sprite.visible = false
	player_mounted_animated_sprite.visible = true
	horse.visible = false

func dismount_player():
	mounted = false
	player_animated_sprite.visible = true
	player_mounted_animated_sprite.visible = false
	horse.visible = true
