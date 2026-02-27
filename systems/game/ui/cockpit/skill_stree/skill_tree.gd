class_name SkillTree
extends CanvasLayer

signal request_load_next_level


@export var skill_scene: PackedScene

@onready var upgrade_system: UpgradeSystem = GlobalData.upgrade_system
@onready var skill_container = %SkillContainer

var upgrade_list: Array[UpgradeDefinition]
var skill_map: Dictionary = {}

func _ready() -> void:
	if upgrade_system: 
		upgrade_system.module_installed.connect(_on_module_installed)
		upgrade_list = upgrade_system.get_all_upgrades()
		update_skill_tree()
				
func update_skill_tree():
	%InstallEffectsButton.visible = !upgrade_system.installed_modules["effects"]
	for upgrade in upgrade_list:	
		if skill_map.has(upgrade.id):
			var _skill = skill_map[upgrade.id]
			_skill.skill_level = upgrade_system.get_level(upgrade.id)
		else:
			var upgrade_def = upgrade_system.get_def(upgrade.id)
			if upgrade_def.required_modules.size() == 0 or check_requirement(upgrade_def.required_modules):
				var new_skill = skill_scene.instantiate()
				var skill_level = upgrade_system.get_level(upgrade.id)
				var skill_cost = upgrade_system.get_upgrade_cost(upgrade_def, skill_level)
				new_skill.skill = upgrade
				new_skill.skill_level = skill_level
				new_skill.skill_cost = skill_cost
				new_skill.upgrade_pressed.connect(on_upgrade_press)
				skill_container.add_child(new_skill)
				skill_map[upgrade.id] = new_skill
		
func check_requirement(modules):
	for module in modules:
		if upgrade_system.installed_modules[module] == false:
			return false
	return true
		
func on_upgrade_press(skill):
	var current_level = upgrade_system.get_level(skill.id)
	if upgrade_system.upgrade(skill):
		prints("upgraded! new level: ", upgrade_system.get_level(skill.id))
		var new_level = upgrade_system.get_level(skill.id)
		var skill_cost = upgrade_system.get_upgrade_cost(upgrade_system.get_def(skill.id), new_level)
		
		var _skill = skill_map[skill.id]
		_skill.skill_level = new_level
		_skill.skill_cost = skill_cost
		_skill.update_ui()

func _on_module_installed(module: String):
	prints("module installed:", module, "update skill tree")
	update_skill_tree()
	
func toggle_visibility():
	visible = !visible
	if visible:
		update_skill_tree()

func on_add_credits(credits: int):
	upgrade_system.on_add_credits(credits)
	

func _on_continue_button_pressed() -> void:
	toggle_visibility()
	request_load_next_level.emit()


func _on_install_effects_button_pressed() -> void:
	upgrade_system.install_module("effects", 1200)
