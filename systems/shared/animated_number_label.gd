class_name AnimatedLabel
extends Label

@export var decimals: int = 0

var units: float = 0: set = _on_units_set
var fake_units: float = 0: set = _on_fake_units_set
var tween: Tween

func _on_units_set(new_value: float):
	units = new_value
	
	if tween:
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "fake_units", units, 0.5)

func _on_fake_units_set(new_value: float):
	fake_units = new_value
	if decimals <= 0:
		text = str(int(round(fake_units)))
	else:
		text = ("%0." + str(decimals) + "f") % fake_units
