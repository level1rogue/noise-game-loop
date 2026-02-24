extends Node

signal on_add_to_credits(credits: int)

var init_count := 100
var timer_interval := 1.0
var enemy_max_speed = 0.5
var enemy_config: EnemySpawnConfig

@export var init = true

@export var enemy : PackedScene

func init_enemies():
#	
	# Instantiate new initial enemies
	for i in init_count:
		_initiate_enemy()

func _on_timer_timeout() -> void:
	_initiate_enemy()
	
func on_beat() -> void:
	pass

func on_bar() -> void:
	pass
	
func _initiate_enemy() -> void:
	var en = enemy.instantiate()
	en.max_speed = enemy_config.speed
	en.max_health = enemy_config.health
	en.color = enemy_config.color
	en.add_to_credits.connect(_on_add_to_credits)
	get_parent().get_parent().add_child(en)

func set_random_values(en):
	en.flicker_speed = randf_range(4.8, 5.2)
	en.noise_frequency = randf_range(0.1, 0.2)
	en.time_offset = randf_range(0.1, 1.0)

#TODO: sync spawn machine to world clock!
func start_level(_enemy_config: Object):
	
	enemy_config = _enemy_config
	
	init_count = enemy_config.init_spawn_count
	enemy_max_speed = enemy_config.speed
	init = true
	$Timer.wait_time = enemy_config.spawn_interval
	if init:
		#remove_all_existing()
		init_enemies()
		init = false
	$Timer.start()

func stop_timer():
	remove_all_existing()
	$Timer.stop()

func end_level():
	remove_all_existing()
	$Timer.stop()

func remove_all_existing():
	# Remove existing enemies
	for child in get_parent().get_parent().get_children():
		if child.has_method("die"):
			child.die("no_credits")
			
func _on_add_to_credits(credits: int):
	on_add_to_credits.emit(credits)
