extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -700.0

# KORREKTUR: Die Gravitationskonstante wurde hinzugefügt, da Godot 4
# die Funktion get_gravity() nicht standardmäßig bereitstellt.
const GRAVITY = 980.0 

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		# Nutzt die definierte GRAVITY Konstante
		velocity.y += GRAVITY * delta

	# Handle jump. (Einfacher Sprung)
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction: -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle_Animation")
		else:
			animated_sprite.play("run_Animation")
	else:
		animated_sprite.play("jump_tmp")
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
