extends Node2D

# Adjustable bounce strength - higher values = higher bounce
@export var bounce_force: float = 900.0
@export var is_pickable: bool = true  # Toggle this to make specific springs pickable or not
@export var pickup_key: String = "interact"  # The key/action to pick up (e.g., "E" key)

# Optional: Animation player reference
@onready var sprite = $Area2D/Sprite2D
@onready var area = $Area2D
@onready var pickup_indicator = $Area2D/PickupIndicator

var player_nearby: Node2D = null
var is_being_carried: bool = false
var carried_by: Node2D = null

func _ready():
	# Connect the area's body_entered signal to our function
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	
		# NEW: Hide the pickup indicator when the game starts
	if pickup_indicator:
		pickup_indicator.visible = false
		
func _process(_delta):
	# If being carried, follow the player
	if is_being_carried and carried_by:
		global_position = carried_by.global_position + Vector2(0, -30)  # Adjust offset as needed

	# Check for pickup input when player is nearby
	if player_nearby and is_pickable and not is_being_carried:
		#if Input.is_action_just_pressed(KEY_E):
		if Input.is_action_just_pressed(pickup_key):
			pickup(player_nearby)
		if Input.is_action_just_pressed(pickup_key):
			print("Pickup button pressed!")  # Should print when you press E
	# Check for drop input when being carried
	if is_being_carried and Input.is_action_just_pressed(pickup_key):
		drop()

func _on_body_entered(body):
	# Check if the body that entered is the player
	if body.is_in_group("player"):
		player_nearby = body
		if pickup_indicator and is_pickable and not is_being_carried:
			pickup_indicator.visible = true  # Show when player nearby
		# Apply upward velocity to the player
				# Only bounce if not being carried and player is falling
		if not is_being_carried and body.velocity.y > 0:
			body.velocity.y = -bounce_force
		# Optional: Play spring animation
			play_spring_animation()

func _on_body_exited(body):
	if body.is_in_group("player") and body == player_nearby:
		player_nearby = null
		if pickup_indicator:
			pickup_indicator.visible = false
			#if pickup_indicator.visible = false:
				#coincounter++   # Hide when player leaves

func pickup(player):
	is_being_carried = true
	carried_by = player
	# Optional: Change appearance when picked up
	sprite.modulate = Color(0.8, 0.8, 1.0)  # Slight blue tint
	# Disable collision while carried
	area.monitoring = false

func drop():
	is_being_carried = false
	carried_by = null
	# Restore appearance
	sprite.modulate = Color(1, 1, 1)
	# Re-enable collision
	area.monitoring = true

func play_spring_animation():
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(1.2, 0.7), 0.1)
	tween.tween_property(sprite, "scale", Vector2(0.9, 1.1), 0.1)
	tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.1)
