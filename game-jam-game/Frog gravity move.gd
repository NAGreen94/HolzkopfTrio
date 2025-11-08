extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_velocity = -400.0
var move_speed = 100.0

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# NPC behavior - example: hop occasionally
	if is_on_floor() and randf() < 0.01:  # 1% chance per frame to hop
		velocity.y = jump_velocity
	
	# Simple AI movement
	velocity.x = move_speed  # Move right (you can add logic to change direction)
	
	move_and_slide()
