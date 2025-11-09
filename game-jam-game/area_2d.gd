extends Area2D


@onready var GameManeger = GameManager

func _ready():
	# Connect the signal
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Check if it's the player
	if body.is_in_group("player"):
		# Add to global counter
		GameManager.add_coin()
		queue_free()
		# Optional: Add a coin collect animation/sound here before disappearing
		# play_collect_animation()
		# Make coin disappear
		
