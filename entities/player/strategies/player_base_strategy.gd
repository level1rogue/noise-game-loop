@abstract
class_name PlayerBaseStrategy extends Resource

@abstract
func apply_upgrade(level: int)

@abstract
func on_shot_fired(player: CharacterBody2D, shot_data: ShotData)
