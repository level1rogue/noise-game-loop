extends Control

var modules := {}

var tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalData.upgrade_system.module_installed.connect(on_module_installed)
	
	var installed_modules = GlobalData.upgrade_system.installed_modules
	
	modules = {
		"sequencer": $SequencerModule,
		"effects_module": $EffectsModule,
		"delay_module": $EffectsModule/DelayModule,
		"reverb_module": $EffectsModule/ReverbModule
	}
	
	for module in installed_modules.keys():
		toggle_module_ui(module, installed_modules[module], true)

	
func toggle_module_ui(_module, _visible, init := false):
	var module = modules[_module]
	prints("module:", module)
	if module:
		if !init:
			if _visible:
				module.modulate.a = 0.0
				module.pivot_offset_ratio = Vector2(0.5, 0.5)
				module.scale = Vector2(1.5, 1.5)
				module.visible = true
				if tween:
					tween.kill()
				tween = create_tween()
				tween.tween_property(module, "modulate:a", 1.0, 0.75)
				tween.parallel().tween_property(module, "scale", Vector2(1.0, 1.0), 0.75)
				$AudioModuleInstall.play()
		else:
			module.visible = _visible
func on_module_installed(module: String):
	toggle_module_ui(module, true)
