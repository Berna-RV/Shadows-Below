extends Node2D

func win():
	print("You Win!!!")
	var current_scene = get_tree().current_scene
	get_tree().reload_current_scene()

func lose():
	print("You Lose!!!")
	var current_scene = get_tree().current_scene
	get_tree().reload_current_scene()
	
