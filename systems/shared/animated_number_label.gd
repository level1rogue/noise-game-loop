class_name AnimatedLabel
extends Label

var credits: int = 0: set = _on_credits_set
var fake_credits: int = 0: set = _on_fake_credits_set
var tween: Tween

func _on_credits_set(new_value: int):
	credits = new_value
	
	if tween:
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "fake_credits", credits, 1.0)

func _on_fake_credits_set(new_value: int):
	fake_credits = new_value
	self.text = str(fake_credits)
