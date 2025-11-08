extends CharacterBody2D

const SPEED = 60

var direction = -1

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var ray_cast_left: RayCast2D = $"RayCast left"
@onready var ray_cast_right: RayCast2D = $"RayCast right"



func _process(delta):
	if ray_cast_left.is_colliding():
		direction = 1
		
		
	if ray_cast_right.is_colliding():
		direction = -1
		
	position.x += direction * SPEED * delta
		

func _on_area_entered(area: CharacterBody2D) -> void:
	

	pass # Replace with function body.
