extends Area2D

func _on_body_entered(body: Node2D) -> void:
	print("body entered")
	if body.has_method("hero"):
		print("It's the hero!")
		body.health_power_up(20)
		queue_free()
	else:
		print("It's not the hero.")
