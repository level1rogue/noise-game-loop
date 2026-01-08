extends Node2D

var INIT_COUNT = 100
@export var init = true

var enemy = preload("res://scenes/enemy.tscn")

func init_enemies():
	# Remove pre-existing enemies
	for child in get_parent().get_children():
		if child.has_method("die"):
			child.die()
	# Instantiate new initial enemies
	for i in INIT_COUNT:
		var en = enemy.instantiate()
		get_parent().add_child(en)

func _on_timer_timeout() -> void:
	if init:
		init_enemies()
		init = false
	var en = enemy.instantiate()
	get_parent().add_child(en)
