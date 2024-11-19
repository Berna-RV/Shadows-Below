extends CharacterBody2D

const SPEED = 25.0

var HEALTH = 100
var MAX_HEALTH = 100

var last_direction := Vector2(1, 0)  # Default to facing right

var HERO_ACTION_READY = true

var hero_alive = true

var ATTACK_DAMAGE = 20

# identifier function
func hero():
	pass

func _physics_process(delta: float) -> void:
	if hero_alive:
		handle_movement_and_attack(delta)
	
func handle_movement_and_attack(delta):
	if HERO_ACTION_READY:
		# Get input for movement 
		var direction := Vector2(
			Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left"),
			Input.get_action_strength("walk_down") - Input.get_action_strength("walk_up")
		).normalized()
		
		# Set velocity based on input direction and speed
		velocity = direction * SPEED
		# Use move_and_slide without arguments to handle movement and respect collisions
		move_and_slide()
		# Update last movement direction if moving
		if direction != Vector2.ZERO:
			last_direction = direction
			
			if Input.is_action_just_pressed("attack") and HERO_ACTION_READY:
				$AnimatedSprite2D.play("attack2")  # Play the attack animation
				HERO_ACTION_READY = false
				$deal_attack_timer.start()
				# start timer 
			else:
				$AnimatedSprite2D.play("walk")  # Play the walk animation
			# Flip sprite horizontally based on left/right movement
			$AnimatedSprite2D.flip_h = last_direction.x < 0
		else:
			if Input.is_action_just_pressed("attack") and HERO_ACTION_READY:
				$AnimatedSprite2D.play("attack1")  # Play the attack animation
				HERO_ACTION_READY = false
				$deal_attack_timer.start()
				# start timer 
			else:
				$AnimatedSprite2D.play("idle")  # Play idle animation when not moving

		move_and_slide()

func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop()
	HERO_ACTION_READY = true

func attack_damage_power_up(power_up):
	ATTACK_DAMAGE += power_up
	print("power up")
	
func health_power_up(power_up):
	MAX_HEALTH += power_up

func heal_power_up(power_up):
	if HEALTH + power_up >= MAX_HEALTH:
		HEALTH = MAX_HEALTH
	else:
		HEALTH += power_up
