extends CanvasLayer

signal start_level
signal load_next_level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Sequencer.call_on_beat.connect(%BPMIndicatorLight.on_beat)
	
	_fit_ui_to_res()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_start_button_pressed() -> void:
	start_level.emit()


func _on_next_level_button_pressed() -> void:
	load_next_level.emit()

func _fit_ui_to_res() -> void:

	$CockpitRoot.scale = Vector2(1.15, 1.15)
