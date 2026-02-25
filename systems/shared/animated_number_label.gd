class_name AnimatedLabel
extends Label

var units: int = 0: set = _on_units_set
var fake_units: int = 0: set = _on_fake_units_set
var tween: Tween

func _on_units_set(new_value: int):
	units = new_value
	
	if tween:
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "fake_units", units, 0.5)

func _on_fake_units_set(new_value: int):
	fake_units = new_value
	self.text = str(fake_units)
