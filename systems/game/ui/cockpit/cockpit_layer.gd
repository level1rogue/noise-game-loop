extends CanvasLayer

signal start_level
signal load_next_level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SkillTree.request_load_next_level.connect(_on_request_load_next_level)
	%Sequencer.call_on_beat.connect(%BPMIndicatorLight.on_beat)	
	%LevelInfoControl.request_start_level.connect(func(): start_level.emit())
	_fit_ui_to_res()


func _on_start_button_pressed() -> void:
	start_level.emit()


func _on_next_level_button_pressed() -> void:
	_on_request_load_next_level()

func _on_request_load_next_level():
	load_next_level.emit()

func _fit_ui_to_res() -> void:
	$CockpitRoot.scale = Vector2(1.15, 1.15)

func toggle_skill_tree():
	$SkillTree.toggle_visibility()
	
