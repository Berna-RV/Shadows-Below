extends CharacterBody2D

const SPEED = 30.0

var HEALTH = 100
var MAX_HEALTH = 100

var last_direction := Vector2(1, 0)  # Default to facing right

var HERO_ACTION_READY = true
var hero_alive = true
var ATTACK_DAMAGE = 20

var is_hero_attacking = false
var enemy_bodies = []
var enemies_in_attack_position = false
var can_be_attacked = true
var animation_state = "idle"  # Tracks the current animation state

func hero():
	pass

func _physics_process(delta: float) -> void:
	if not hero_alive:
		return  # Skip processing if the hero is dead

	if animation_state in ["hurt", "death"]:
		return  # Skip movement and attack while in hurt or death state

	deal_with_damage()
	handle_movement_and_attack(delta)

func handle_movement_and_attack(delta):
	var direction = Vector2(
		Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left"),
		Input.get_action_strength("walk_down") - Input.get_action_strength("walk_up")
	).normalized()

	velocity = direction * SPEED

	if direction != Vector2.ZERO:
		last_direction = direction
		if animation_state != "walk" and not is_hero_attacking:
			animation_state = "walk"
			$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = last_direction.x < 0
	else:
		if animation_state != "idle" and not is_hero_attacking:
			animation_state = "idle"
			$AnimatedSprite2D.play("idle")

	if Input.is_action_just_pressed("attack") and HERO_ACTION_READY and not is_hero_attacking:
		perform_attack()

	move_and_slide()

func perform_attack():
	animation_state = "attack"
	is_hero_attacking = true
	HERO_ACTION_READY = false
	$AnimatedSprite2D.play("attack1")
	$deal_attack_timer.start()

func deal_with_damage():
	if enemies_in_attack_position:
		for enemy in enemy_bodies:
			if enemy.is_enemy_attacking and can_be_attacked:
				can_be_attacked = false
				HEALTH -= enemy.ATTACK_DAMAGE
				$ProgressBar.value = HEALTH
				$hurt_animation_time.start()
				animation_state = "hurt"
				$AnimatedSprite2D.play("hurt")
				$damage_cool_down.start()
				if HEALTH <= 0:
					die()

func die():
	hero_alive = false
	animation_state = "death"
	$AnimatedSprite2D.play("death")
	$death_time.start()  # Ensure this matches the animation duration
	
func attack_damage_power_up(power_up):
	ATTACK_DAMAGE += power_up
	print("Damage power up!!!")
	
func health_power_up(power_up):
	MAX_HEALTH += power_up
	$ProgressBar.max_value = MAX_HEALTH
	print("Health power up!!!")

func heal_power_up(power_up):
	if HEALTH + power_up >= MAX_HEALTH:
		HEALTH = MAX_HEALTH
	else:
		HEALTH += power_up
	$ProgressBar.value = HEALTH
	print("Heal power up!!!")

func _on_deal_attack_timer_timeout() -> void:
	is_hero_attacking = false
	HERO_ACTION_READY = true
	if velocity != Vector2.ZERO:
		animation_state = "walk"
		$AnimatedSprite2D.play("walk")
	else:
		animation_state = "idle"
		$AnimatedSprite2D.play("idle")

func _on_damage_cool_down_timeout() -> void:
	can_be_attacked = true

func _on_hurt_animation_time_timeout() -> void:
	if HEALTH > 0:
		animation_state = "idle"
		$AnimatedSprite2D.play("idle")

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_bodies.append(body)
		enemies_in_attack_position = true

func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_bodies.erase(body)
		if enemy_bodies.is_empty():
			enemies_in_attack_position = false

func _on_death_time_timeout() -> void:
	# Ensure the death animation completes before disappearing
	$AnimatedSprite2D.visible = false
	Dungeon.lose()
