extends Node2D

var start_radius := 50.0
var target_radius := 200.0
var current_radius := 50.0
var duration := 0.5
var damage := 10
var ring_width := 10.0

var elapsed := 0.0
var hit_enemies: Array = []  # Track which enemies we've already hit

func _ready() -> void:
		queue_redraw()

func setup(initial_radius: float, end_radius: float, shockwave_damage: int = 10, shockwave_duration: float = 0.5):
		start_radius = initial_radius
		current_radius = initial_radius
		target_radius = end_radius
		damage = shockwave_damage
		duration = shockwave_duration
		queue_redraw()

func _process(delta: float) -> void:
		elapsed += delta
		var progress = elapsed / duration
		
		if progress >= 1.0:
				queue_free()
				return
		
		# Expand radius
		current_radius = lerp(start_radius, target_radius, progress)
		queue_redraw()
		
		# Check for enemies in ring area
		_check_collisions()

func _check_collisions():
		# Use a query to find bodies in the area
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsShapeQueryParameters2D.new()
		
		# Create circle shape at current radius
		var shape = CircleShape2D.new()
		shape.radius = current_radius + ring_width / 2
		query.shape = shape
		query.transform = Transform2D(0, global_position)
		query.collision_mask = 2  # Enemy layer
		
		var results = space_state.intersect_shape(query)
		
		for result in results:
				var body = result.collider
				# Check if enemy is within the ring (not inside inner circle)
				var distance = global_position.distance_to(body.global_position)
				if distance >= current_radius - ring_width / 2 and distance <= current_radius + ring_width / 2:
						# Enemy is in the ring
						if not body in hit_enemies:
								hit_enemies.append(body)
								if body.has_method("take_damage"):
										body.take_damage(damage)

func _draw() -> void:
		# Draw expanding ring
		draw_arc(Vector2.ZERO, current_radius, 0, TAU, 64, Color.CYAN, ring_width * 0.3, true)
		
		# Fade out effect
		modulate.a = 1.0 - (elapsed / duration)
