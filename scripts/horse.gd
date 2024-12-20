extends Node2D

@onready var horse_animated_sprite = $HorseAnimatedSprite2D
@onready var reaction_timer = $ReactionTimer  # A Timer node added to the horse
@onready var snort_audio = $SnortAudioStreamPlayer2D

# Constants for animations
const ANIM_IDLE = "idle"
const ANIM_REACTION_1 = "reaction_1"
const ANIM_REACTION_2 = "reaction_2"

var snort_sounds = [
	preload("res://audio/horse/horse_snort_1.ogg"),
	preload("res://audio/horse/horse_snort_2.ogg"),
	preload("res://audio/horse/horse_snort_3.ogg"),
	preload("res://audio/horse/horse_snort_4.ogg"),
]

func _ready():
	# Ensure the horse starts in idle animation
	horse_animated_sprite.play(ANIM_IDLE)
	
	# Start the reaction timer
	reaction_timer.wait_time = randf_range(3.0, 10.0)  # Random wait time between reactions
	reaction_timer.start()

func _on_reaction_timer_timeout():
	# Randomly choose one of the reactions
	var reaction = ANIM_REACTION_1
	if randi() % 2 == 0:
		reaction = ANIM_REACTION_2
	snort_audio.stream = snort_sounds[randi() % snort_sounds.size()]
	snort_audio.play()
	horse_animated_sprite.play(reaction)

	# Wait for the reaction animation to finish, then return to idle
	await horse_animated_sprite.animation_finished
	horse_animated_sprite.play(ANIM_IDLE)

	# Restart the timer with a new random interval
	reaction_timer.wait_time = randf_range(3.0, 10.0)
	reaction_timer.start()
