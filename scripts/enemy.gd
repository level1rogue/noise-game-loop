extends CharacterBody2D

var MIN_SPEED := 0.01
var MAX_SPEED := 0.5

var SPEED := 0.0
var DIRECTION := Vector2(0,0)

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
	go_go_go = true
