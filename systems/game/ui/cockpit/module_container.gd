extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalData.upgrade_system.module_installed.connect(on_module_installed)
	
	var installed_modules = GlobalData.upgrade_system.installed_modules
	for module in installed_modules.keys():
		toggle_module_ui(module, installed_modules[module])


func toggle_module_ui(module, _visible):
	match module:
		"sequencer":
			$SequencerModule.visible = _visible
		"effects_module":
			$EffectsModule.visible = _visible
		"delay_module":
			$EffectsModule/DelayModule.visible = _visible
		"reverb_module":
			$EffectsModule/ReverbModule.visible = _visible


func on_module_installed(module: String):
	toggle_module_ui(module, true)
