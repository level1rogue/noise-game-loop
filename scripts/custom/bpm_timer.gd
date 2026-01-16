@tool
extends Timer
class_name BPMTimer

@export var BPM: float = 120.0
@export var Steps: int = 16

func _validate_property(property: Dictionary) -> void:
	if property.name == "wait_time":
		property.usage &= ~PROPERTY_USAGE_EDITOR

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var bpm_in_sec = 60.0 / BPM
	self.start(bpm_in_sec)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_timeout() -> void:
	prints("timeout! ", self.wait_time)
