extends Area2D

signal activated

var player_nearby = false

func _ready():
	# Connect the Area2D signals
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	# Check if the player entered the area
	if body.name == "Player":  # Adjust this to match your player's node name
		player_nearby = true
		print("Press E to activate switch")

func _on_body_exited(body):
	# Check if the player left the area
	if body.name == "Player":
		player_nearby = false
		print("Left switch area")

func _process(_delta):
	# Check if player is nearby AND presses E
	if player_nearby and Input.is_action_just_pressed("interact"):
		emit_signal("activated")
		print("Switch activated!")
