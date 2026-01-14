extends Node2D

var init_count = 100
var timer_interval = 1
var enemy_max_speed = 0.5
@export var init = true

var enemy = load("res://scenes/enemy.tscn")

func init_enemies():
	
	# Instantiate new initial enemies
	for i in init_count:
		var en = enemy.instantiate()
		en.max_speed = enemy_max_speed
		#set_random_values(en)
		get_parent().add_child(en)

func _on_timer_timeout() -> void:
	
	var en = enemy.instantiate()
	en.max_speed = enemy_max_speed
	#set_random_values(en)
	get_parent().add_child(en)
	
func set_random_values(en):
	en.flicker_speed = randf_range(4.8, 5.2)
	en.noise_frequency = randf_range(0.1, 0.2)
	en.time_offset = randf_range(0.1, 1.0)

func start_timer(data: Dictionary):
	init_count = data.init_enemies
	enemy_max_speed = data.enemy_max_speed
	init = true
	$Timer.wait_time = data.timer_interval
	if init:
		remove_all_existing()
		init_enemies()
		init = false
	$Timer.start()

func stop_timer():
	remove_all_existing()
	$Timer.stop()

func remove_all_existing():
	# Remove existing enemies
	for child in get_parent().get_children():
		if child.has_method("die"):
			child.die()
