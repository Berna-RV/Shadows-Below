extends CharacterBody2D

const SPEED = 20.0

var HEALTH = 100
var ATTACK_DAMAGE = 10

var in_hero_chase = false
var hero_body = null

var is_hero_in_attack_position = false
var can_be_attacked = true
var animation_state = "idle" # Tracks the current animation state

func enemy(): # identifyer function
	pass
	
func _physics_process(delta: float) -> void:
	deal_with_damage()

	if animation_state == "hurt" or animation_state == "death":
		# Don't override hurt or death animations
		return

	if in_hero_chase and hero_body != null:
		var direction = (hero_body.position - position).normalized()
		position += direction * SPEED * delta

		# Update animation state
		animation_state = "walk"
		$AnimatedSprite2D.play("walk")

		# Flip the sprite based on the direction of movement
		$AnimatedSprite2D.flip_h = direction.x < 0
	else:
		# Update animation state
		animation_state = "idle"
		$AnimatedSprite2D.play("idle")

	move_and_collide(Vector2(0, 0))

func deal_with_damage():
	if is_hero_in_attack_position and hero_body.is_hero_attacking and can_be_attacked:
		print("hit")
		HEALTH -= hero_body.ATTACK_DAMAGE

		# Play hurt animation and update animation state
		animation_state = "hurt"
		$AnimatedSprite2D.play("hurt")
		can_be_attacked = false
		$take_damage_cooldown.start()

		if HEALTH <= 0:
			print("enemy killed")
			animation_state = "death"
			$AnimatedSprite2D.play("death")
			$death_time.start()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.has_method("hero"):
		hero_body = body
		in_hero_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.has_method("hero"):
		hero_body = null
		in_hero_chase = false

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("hero"):
		hero_body = body
		is_hero_in_attack_position = true

func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("hero"):
		hero_body = null
		is_hero_in_attack_position = false

func _on_take_damage_cooldown_timeout() -> void:
	$take_damage_cooldown.stop()
	can_be_attacked = true

	# Return to idle or chase animation after hurt animation finishes
	if in_hero_chase:
		animation_state = "walk"
		$AnimatedSprite2D.play("walk")
	else:
		animation_state = "idle"
		$AnimatedSprite2D.play("idle")

func _on_death_time_timeout() -> void:
	$death_time.stop()
	self.queue_free()
