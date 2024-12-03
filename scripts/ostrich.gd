extends Node2D

@onready var ostrich_animated_sprite = $OstrichAnimatedSprite2D
@onready var ostrich_timer = $OstrichTimer  # Timer node to control intervals

# Constants for animations
const ANIM_IDLE = "idle"
const ANIM_WALK = "walk"

# Movement settings
var walk_distance = 100
var walk_speed = 50 
var is_moving = false
var direction = Vector2(1, 0)

func _ready():
	ostrich_animated_sprite.play(ANIM_IDLE)
	
	ostrich_timer.wait_time = randf_range(3.0, 7.0)
	ostrich_timer.start()
	
func _process(delta):
	if is_moving:
		position += direction * walk_speed * delta
		walk_distance -= walk_speed * delta

		if walk_distance <= 0:
			is_moving = false
			walk_distance = randi_range(50, 120)
			ostrich_animated_sprite.play(ANIM_IDLE)

			ostrich_timer.wait_time = randf_range(3.0, 7.0)
			ostrich_timer.start()
	
func _on_ostrich_timer_timeout():
	var random_dir
	if randi() % 2 == 0:
		random_dir = 1
	else:
		random_dir = -1
	direction = Vector2(random_dir, 0)
	
	ostrich_animated_sprite.flip_h = (direction.x == 1)
	
	is_moving = true
	ostrich_animated_sprite.play(ANIM_WALK)
