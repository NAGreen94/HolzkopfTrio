extends Node2D

# Adjustable bounce strength - higher values = higher bounce
@export var bounce_force: float = 900.0

# Optional: Animation player reference
@onready var sprite = $Area2D/Sprite2D
@onready var area = $Area2D

func _ready():
	# Connect the area's body_entered signal to our function
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Check if the body that entered is the player
	if body.is_in_group("player"):
		# Apply upward velocity to the player
		if body.velocity.y > 0:
			body.velocity.y = -bounce_force
		# Optional: Play spring animation
			play_spring_animation()

func play_spring_animation():
	# Create a simple squash/stretch animation with code
	var tween = create_tween()
	# Squash down
	tween.tween_property(sprite, "scale", Vector2(1.2, 0.7), 0.1)
	# Spring back up
	tween.tween_property(sprite, "scale", Vector2(0.9, 1.1), 0.1)
	# Return to normal
	tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.1)
