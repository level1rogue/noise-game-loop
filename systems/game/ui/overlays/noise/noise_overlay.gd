extends CanvasLayer

@export var upgrade_system: UpgradeSystem

var noise_intensity: float = 0

func _ready() -> void:
	apply_noise()
	upgrade_system.noise_changed.connect(set_noise_level)


func set_noise_level():
	var noise_level = upgrade_system.noise
	if noise_level >= GlobalData.DEADLY_NOISE_AMOUNT / 2:
		noise_intensity = (noise_level - GlobalData.DEADLY_NOISE_AMOUNT / 2) / 100.0
	else:
		noise_intensity = 0.0
	apply_noise()
	
	
func apply_noise():
	$ShaderPanel.material.set_shader_parameter("static_noise_intensity", noise_intensity)
