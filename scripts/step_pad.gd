extends Control
class_name StepPad

var step_index: int
var active_state := false
var highlight_state := false
var icon : Sprite2D

func _ready() -> void:
	_update_visual()
	
func set_icon(icon: String):
	$Icon.set_icon(icon)
	

func set_active(active: bool):
	active_state = active
	_update_visual()
	
func set_highlight(highlight: bool):
	highlight_state = highlight
	_update_visual()
	
func _update_visual():
	if active_state:
		$ColorRect.color = Color("189758ff")
	elif highlight_state:
		$ColorRect.color = Color("45343bff")
	else:
		$ColorRect.color = Color("0b0b0bff")
