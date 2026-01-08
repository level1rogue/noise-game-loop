extends CharacterBody2D

const SPEED = 500.0

func _physics_process(delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	
	var direction = mouse_pos - global_position
	
	if direction.length() > 1:
		velocity = direction.normalized() * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()

func trigger_shot():
	print("shoot!", $AnimationPlayer.current_animation)
	$AnimationPlayer.play("shot")
	$ShotAudio.play()
	
	var enemies = $ShotArea.get_overlapping_bodies()
	for enemy in enemies:
		if enemy.has_method("take_damage"):
			enemy.take_damage(5)

func _on_timer_timeout() -> void:
	trigger_shot()
