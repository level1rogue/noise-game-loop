extends Node2D

var init_count = 100
var timer_interval = 1
var enemy_max_speed = 0.5
@export var init = true

var enemy = preload("res://scenes/enemy.tscn")


func init_enemies():
	# Remove pre-existing enemies
	for child in get_parent().get_children():
		if child.has_method("die"):
			child.die()
	# Instantiate new initial enemies
	for i in init_count:
		var en = enemy.instantiate()
		en.max_speed = enemy_max_speed
		get_parent().add_child(en)

func _on_timer_timeout() -> void:
	
	var en = enemy.instantiate()
	en.max_speed = enemy_max_speed
	get_parent().add_child(en)

func start_timer(data: Dictionary):
	init_count = data.init_enemies
	enemy_max_speed = data.enemy_max_speed
	init = true
	$Timer.wait_time = data.timer_interval
	if init:
		init_enemies()
		init = false
	$Timer.start()
