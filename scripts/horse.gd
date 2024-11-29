extends Node2D

var speed = 80

var player_in_area = false
var mounted = false 

@onready var player = get_node("../Player")
@onready var horse_sprite = $HorseSprite

@onready var player_mounted_texture = preload("res://images/PlayerMounted.png")
@onready var horse_texture = preload("res://images/Horse.png")

func _on_area_2d_area_entered(body):
	if body.name == "PlayerArea2D":
		player_in_area = true

func _on_area_2d_area_exited(body):
	if body.name == "PlayerArea2D":
		player_in_area = false
		
func _process(delta):
	if Input.is_action_just_pressed("interact") and player_in_area and not mounted:
		mount_player()
	elif Input.is_action_just_pressed("interact") and mounted:
		dismount_player()
		
	if mounted:
		if Input.is_action_pressed("move_right"):
			position.x += speed * delta
			horse_sprite.flip_h = true
		elif Input.is_action_pressed("move_left"):
			position.x -= speed * delta
			horse_sprite.flip_h = false
		
func mount_player():
	mounted = true
	player.visible = false
	horse_sprite.texture = player_mounted_texture

func dismount_player():
	mounted = false
	player.visible = true
	horse_sprite.texture = horse_texture
