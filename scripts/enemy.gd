extends CharacterBody2D

@export var deathParticles : PackedScene

var MIN_SPEED := 0.01
var MAX_SPEED := 0.5

var SPEED := 0.0
var DIRECTION := Vector2(0,0)

var MAX_HEALTH := 10.0
var health = MAX_HEALTH

var go_go_go := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initiate_me()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if go_go_go:
		velocity += DIRECTION * SPEED * delta
		move_and_slide()

func initiate_me():
	SPEED = randf_range(MIN_SPEED, MAX_SPEED)
	DIRECTION = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
	position = get_viewport_rect().size / 2 + DIRECTION * randi_range(20, 90)
	var noise_color_value = randf() 
	$ColorRect.color = Color(noise_color_value, noise_color_value, noise_color_value, 1.0)
	
	# Set random flicker offset for each enemy
	var material = $ColorRect/TextureRect.material as ShaderMaterial
	material.set_shader_parameter("time_offset", randf_range(0.0, 100.0))
	
	go_go_go = true

func take_damage(amount: int):
	health -= amount
	$ColorRect.color.a = health / MAX_HEALTH
	if health <= 0:
		die()
		
func die():
	var _particle = deathParticles.instantiate()
	get_tree().current_scene.add_child(_particle)
	_particle.global_position = global_position
	_particle.emitting = true

	queue_free()
