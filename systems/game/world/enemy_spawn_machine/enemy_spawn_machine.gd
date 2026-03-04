extends Node2D

signal on_add_to_credits(credits: int)
signal on_add_to_noise(noise: int)

@export var enemy_spawn_control: PackedScene

@onready var metaball := $CanvasLayer/MetaballField

var enemy_controls := []

func _ready():
	# Set viewport size for shader
	var viewport_size = get_viewport_rect().size
	metaball.material.set_shader_parameter("viewport_size", viewport_size)

func _process(delta: float) -> void:
	var enemies = get_tree().get_nodes_in_group("enemies")
	
	# Convert enemy world positions to screen positions
	var positions: Array[Vector2] = []
	var canvas_transform = get_canvas_transform()
	for e in enemies:
		var screen_pos = canvas_transform * e.global_position
		positions.append(screen_pos)
	
	metaball.material.set_shader_parameter("enemy_count", positions.size())
	metaball.material.set_shader_parameter("enemy_positions", positions)
	#prints("screen positions:", positions)

#TODO: sync spawn machine to world clock!
func start_level(_level: LevelData):
	for enemy_config in _level.enemy_configs:
		var enemy_control = enemy_spawn_control.instantiate()
		enemy_control.on_add_to_credits.connect(_on_add_to_credits)
		enemy_control.on_add_to_noise.connect(_on_add_to_noise)
		add_child(enemy_control)
		enemy_controls.append(enemy_control)
		enemy_control.start_level(enemy_config)

func stop_timer():
	for enemy_control in enemy_controls:
		enemy_control.stop_timer()

func end_level():
	for enemy_control in enemy_controls:
		enemy_control.end_level()

func on_beat(beat: int):
	pass
func on_bar(bar: int):
	pass

func _on_add_to_credits(credits: int):
	on_add_to_credits.emit(credits)

func _on_add_to_noise(noise: int):
	on_add_to_noise.emit(noise)
