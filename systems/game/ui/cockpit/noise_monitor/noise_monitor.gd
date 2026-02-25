extends Control

@export var upgrade_system: UpgradeSystem

var noise: float = 3.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	upgrade_system.noise_changed.connect(func(): update_noise(upgrade_system.noise))
	update_noise(noise)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_noise(_noise: float):
	noise = _noise
	%NoiseLabel.text = str(noise)
