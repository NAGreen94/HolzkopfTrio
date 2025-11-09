extends Node2D

# Adjustable bounce strength - higher values = higher bounce
@export var bounce_force: float = 900.0
@export var is_pickable: bool = true  # Toggle this to make specific springs pickable or not
@export var pickup_key: String = "interact"  # The key/action to pick up (e.g., "E" key)
@export var carry_offset: Vector2 = Vector2(0, -30)  # Offset from player when carried

# Optional: Animation player reference
@onready var sprite = $Area2D/Sprite2D
@onready var bounce_area = $Area2D  # For bouncing
@onready var pickup_area = $Area2D2  # For pickup detection
@onready var pickup_indicator = $Area2D/PickupIndicator

var player_nearby: Node2D = null
var is_being_carried: bool = false
var carried_by: Node2D = null
var can_pickup: bool = true  # NEW: Prevents immediate drop after pickup

func _ready():
	# Connect the bounce area's body_entered signal
	bounce_area.body_entered.connect(_on_bounce_area_entered)
	
	# Connect the pickup area's signals
	pickup_area.body_entered.connect(_on_pickup_area_entered)
	pickup_area.body_exited.connect(_on_pickup_area_exited)
	
	# NEW: Hide the pickup indicator when the game starts
	if pickup_indicator:
		pickup_indicator.visible = false
		
func _process(_delta):
	# If being carried, follow the player
	if is_being_carried and carried_by:
		global_position = carried_by.global_position + carry_offset  # Adjust offset as needed
		
		# Check for drop input when being carried
		if Input.is_action_just_pressed(pickup_key) and can_pickup:
			print("Drop button pressed!")
			drop()
			can_pickup = false  # Prevent immediate re-pickup
	else:
		# Check for pickup input when player is nearby
		if player_nearby and is_pickable and not is_being_carried:
			# Debug: Print when checking for input
			if Input.is_action_just_pressed(pickup_key) and can_pickup:
				print("Pickup button pressed! Attempting pickup...")
				print("Player nearby: ", player_nearby)
				print("Is pickable: ", is_pickable)
				print("Is being carried: ", is_being_carried)
				pickup(player_nearby)
				can_pickup = false  # Prevent immediate drop
	
	# Reset the pickup flag when button is released
	if Input.is_action_just_released(pickup_key):
		can_pickup = true

# Bounce detection - only handles bouncing
func _on_bounce_area_entered(body):
	# Check if the body that entered is the player
	if body.is_in_group("player"):
		print("Bounce area detected player")
		# Apply upward velocity to the player
		# Only bounce if not being carried and player is falling
		if not is_being_carried and body.velocity.y > 0:
			body.velocity.y = -bounce_force
			# Optional: Play spring animation
			play_spring_animation()

# Pickup detection - only handles pickup area
func _on_pickup_area_entered(body):
	print("Pickup area entered by: ", body.name)
	if body.is_in_group("player"):
		print("Player detected in pickup area!")
		player_nearby = body
		if pickup_indicator and is_pickable and not is_being_carried:
			pickup_indicator.visible = true  # Show when player nearby

func _on_pickup_area_exited(body):
	print("Pickup area exited by: ", body.name)
	if body.is_in_group("player") and body == player_nearby:
		print("Player left pickup area")
		player_nearby = null
		if pickup_indicator:
			pickup_indicator.visible = false  # Hide when player leaves

func pickup(player):
	print("PICKUP FUNCTION CALLED!")
	is_being_carried = true
	carried_by = player
	# Optional: Change appearance when picked up
	sprite.modulate = Color(0.8, 0.8, 1.0)  # Slight blue tint
	# Disable collision while carried
	bounce_area.monitoring = false
	pickup_area.monitoring = false
	# Hide pickup indicator
	if pickup_indicator:
		pickup_indicator.visible = false
	print("Spring is now being carried by: ", carried_by.name)

func drop():
	print("DROP FUNCTION CALLED!")
	is_being_carried = false
	carried_by = null
	# Restore appearance
	sprite.modulate = Color(1, 1, 1)
	# Re-enable collision
	bounce_area.monitoring = true
	pickup_area.monitoring = true
	print("Spring dropped at position: ", global_position)

func play_spring_animation():
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(1.2, 0.7), 0.1)
	tween.tween_property(sprite, "scale", Vector2(0.9, 1.1), 0.1)
	tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.1)
