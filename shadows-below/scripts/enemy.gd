extends CharacterBody2D

const SPEED = 25.0

var HEALTH = 100
var ATTACK_DAMAGE = 30

var in_hero_chase = false
var hero_body = null

var is_hero_in_attack_position = false
var can_be_attacked = true
var animation_state = "idle"  # Tracks the current animation state

var is_enemy_attacking = false

func enemy():
	pass

func _physics_process(delta: float) -> void:
	deal_with_damage()

	if animation_state in ["hurt", "death", "attack"]:
		return  # Skip movement during these animations

	if in_hero_chase and hero_body != null:
		var direction = (hero_body.position - position).normalized()
		velocity = direction * SPEED
		move_and_slide()

		if animation_state != "walk":  # Avoid redundant playback
			animation_state = "walk"
			$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		velocity = Vector2.ZERO
		if animation_state != "idle":
			animation_state = "idle"
			$AnimatedSprite2D.play("idle")
			
func deal_with_damage():
	if is_hero_in_attack_position and hero_body != null:
		if hero_body.is_hero_attacking and can_be_attacked:
			can_be_attacked = false
			HEALTH -= hero_body.ATTACK_DAMAGE
			animation_state = "hurt"
			$AnimatedSprite2D.play("hurt")
			$take_damage_cooldown.start()
			$ProgressBar.value = HEALTH
			if HEALTH <= 0:
				die()
		elif can_be_attacked:
			is_enemy_attacking = true
			animation_state = "attack"
			$AnimatedSprite2D.play("attack")
			$attack_time.start()

func die():
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
		is_hero_in_attack_position = true

func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("hero"):
		is_hero_in_attack_position = false

func _on_take_damage_cooldown_timeout() -> void:
	can_be_attacked = true
	if in_hero_chase:
		animation_state = "walk"
		$AnimatedSprite2D.play("walk")
	else:
		animation_state = "idle"
		$AnimatedSprite2D.play("idle")

func _on_death_time_timeout() -> void:
	queue_free()

func _on_attack_time_timeout() -> void:
	is_enemy_attacking = false
	if in_hero_chase:
		animation_state = "walk"
		$AnimatedSprite2D.play("walk")
	else:
		animation_state = "idle"
		$AnimatedSprite2D.play("idle")
