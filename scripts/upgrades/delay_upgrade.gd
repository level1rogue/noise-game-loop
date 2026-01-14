extends BaseUpgrade

func on_shot_fired(shot_data: Dictionary) -> void:
	prints("shot with delay", shot_data)
