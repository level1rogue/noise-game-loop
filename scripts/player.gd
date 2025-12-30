extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	
	var direction = mouse_pos - global_position
	
	if direction.length() > 1:
		velocity = direction.normalized() * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()
