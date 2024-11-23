extends Node2D

var is_hero_near = false
var hero_body = null
var chest_is_open = false

func _process(delta: float) -> void:
	if is_hero_near and Input.is_action_just_pressed("open_chest") and !chest_is_open:
		print("Opening chest...")
		$AnimatedSprite2D.play("open_chest")
		if hero_body and hero_body.has_method("attack_damage_power_up"):
			hero_body.attack_damage_power_up(20)
			$time_to_open_chest.start()
	elif !chest_is_open:
		$AnimatedSprite2D.play("closed_chest")
	else:
		$AnimatedSprite2D.play("opened_chest")
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("hero"):
		print("Press \"E\" to open the chest!!")
		is_hero_near = true
		hero_body = body  # Save the hero reference

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == hero_body:
		is_hero_near = false
		hero_body = null  # Clear the hero reference

func _on_time_to_open_chest_timeout() -> void:
	$time_to_open_chest.stop()
	chest_is_open = true
	
