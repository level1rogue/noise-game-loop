extends CanvasLayer

var option1 : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_level_rewards(level: LevelData):
	if level != null:
		prints("set rewards: ", level)
		visible = true
	else:
		prints("rewards, no level set")

func _on_continue_button_pressed() -> void:
	visible = false
