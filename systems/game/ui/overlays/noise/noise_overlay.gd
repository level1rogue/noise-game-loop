extends CanvasLayer

@export var upgrade_system: UpgradeSystem

var noise_intensity: float = 0
var tween: Tween

func _ready() -> void:
	$ShaderPanel.material = $ShaderPanel.material.duplicate()
	apply_noise()
	upgrade_system.noise_changed.connect(set_noise_level)


func set_noise_level():
	var prev_intensity = noise_intensity
	var noise_level = upgrade_system.noise
	if noise_level >= GlobalData.DEADLY_NOISE_AMOUNT / 2:
		# Normalize to 0-1 range
		var normalized = (noise_level - GlobalData.DEADLY_NOISE_AMOUNT / 2) / (GlobalData.DEADLY_NOISE_AMOUNT / 2)
		# Exponential curve: starts slow, gets steeper
		noise_intensity = pow(normalized, 2.0)  # Adjust exponent for more/less steepness

	else:
		noise_intensity = 0.0
	apply_noise()
	
	
func apply_noise():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($ShaderPanel.material, "shader_parameter/static_noise_intensity", noise_intensity, 0.75)
	#$ShaderPanel.material.set_shader_parameter("static_noise_intensity", noise_intensity)
