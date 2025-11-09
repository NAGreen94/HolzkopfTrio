extends CharacterBody2D

const SPEED = 160.0
const JUMP_VELOCITY = -300.0

# NEU: Gravitationskonstante definieren
# WICHTIG: Ersetze 980.0 durch den Wert, den du in deinen Projekt-Einstellungen hast (Physics/2D/Default Gravity).
const GRAVITY = 980.0 

# Neue Konstanten für den aufladbaren Sprung
const MAX_CHARGE_TIME = 0.01 # Maximale Aufladezeit in Sekunden
const MAX_JUMP_BOOST = -350.0 # Zusätzliche maximale negative Y-Geschwindigkeit (höherer Sprung)
const MIN_JUMP_VELOCITY = -50.0 # Minimale Sprunggeschwindigkeit bei kurzem Tippen

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Neue Variablen für den aufladbaren Sprung
var is_charging_jump = false
var charge_timer = 0.0
var final_jump_velocity = JUMP_VELOCITY



func _physics_process(delta: float) -> void:
	# 1. Gravitation anwenden (KORRIGIERT)
	if not is_on_floor():
		# Nutzt die definierte GRAVITY Konstante
		velocity.y += GRAVITY * delta - 3

	# 2. Sprung-Auflade-Logik
	if is_on_floor():
		# A. Aufladen starten (Taste gerade gedrückt)
		if Input.is_action_just_pressed("jump"):
			is_charging_jump = true
			charge_timer = 0.0
			
		# B. Aufladen fortsetzen (Taste wird gehalten)
		if is_charging_jump and Input.is_action_pressed("jump"):
			# Lade-Timer erhöhen, maximal bis zur MAX_CHARGE_TIME
			charge_timer = min(charge_timer + delta, MAX_CHARGE_TIME)
			
			# Berechne die endgültige Sprunggeschwindigkeit basierend auf der Ladezeit
			var charge_ratio = charge_timer / MAX_CHARGE_TIME
			
			# Interpolation des Sprungwerts
			final_jump_velocity = MIN_JUMP_VELOCITY + charge_ratio * (JUMP_VELOCITY + MAX_JUMP_BOOST - MIN_JUMP_VELOCITY)

		# C. Springen ausführen (Taste gerade losgelassen oder maximale Zeit erreicht)
		if is_charging_jump and (Input.is_action_just_released("jump") or charge_timer >= MAX_CHARGE_TIME):
			
			velocity.y = final_jump_velocity
			is_charging_jump = false # Aufladevorgang beenden
			
	# Falls man beim Springen die Taste loslässt, um den is_charging_jump Status zu löschen
	if not is_on_floor() and is_charging_jump and Input.is_action_just_released("jump"):
		is_charging_jump = false


	# 3. Bewegungs-Logik
	
	# Get the input direction: -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
	
	
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Play animations
	if is_on_floor():
		# NEU: Zeige "charging" während des Aufladens
		if Input.is_action_pressed("jump"):
			$Jump.play()
		if is_charging_jump:
			# HINWEIS: Du musst diese Animation im AnimatedSprite2D erstellen!
			animated_sprite.play("jump_tmp") 
		elif direction == 0:
			animated_sprite.play("idle_Animation")
		else:
			animated_sprite.play("run_Animation")
	else:
		animated_sprite.play("jump_tmp")
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# 4. Bewegen
	move_and_slide()
