class_name SkillTree
extends CanvasLayer

signal request_load_next_level

@export var skill_scene: PackedScene
@export var module_button_scene: PackedScene

@onready var upgrade_system: UpgradeSystem = GlobalData.upgrade_system
@onready var skill_container = %SkillContainer
@onready var module_container = %ModuleUnlockContainer

var upgrade_list: Array[UpgradeDefinition]
var skill_map: Dictionary = {}
var module_button_map: Dictionary = {}

func _ready() -> void:
	if upgrade_system: 
		upgrade_system.module_installed.connect(_on_module_installed)
		upgrade_list = upgrade_system.get_all_upgrades()
		update_skill_tree()
				
func update_skill_tree():
	clear_containers()
	prints("Total upgrades:", upgrade_list.size())
	for upgrade in upgrade_list:	
		var upgrade_def = upgrade_system.get_def(upgrade.id)
		var missing_modules = get_missing_modules(upgrade_def.required_modules)
		prints("Upgrade:", upgrade_def.id, "Missing modules:", missing_modules)
		
		if missing_modules.is_empty():
			# show skill upgrade 
			create_or_update_skill(upgrade_def)
		else:
			# show module unlock buttons for missing modules
			create_module_buttons(missing_modules, upgrade_def)	
			
func clear_containers():
	for child in skill_container.get_children():
		child.queue_free()
	for child in module_container.get_children():
		child.queue_free()
	skill_map.clear()
	module_button_map.clear()
	
func get_missing_modules(required_modules: Array[String]) -> Array[String]:
	var missing: Array[String] = []
	prints("Checking required modules:", required_modules)
	prints("Installed modules:", upgrade_system.installed_modules)	
	for module in required_modules:
		if not upgrade_system.installed_modules.get(module):
			missing.append(module)
	prints("Missing modules found:", missing)
	return missing
	
func check_requirement(modules):
	return get_missing_modules(modules).is_empty()
	
func create_or_update_skill(upgrade_def: UpgradeDefinition):
	var skill_level = upgrade_system.get_level(upgrade_def.id)
	var skill_cost = upgrade_system.get_upgrade_cost(upgrade_def, skill_level)
	
	var skill_node = skill_scene.instantiate()
	skill_node.skill = upgrade_def
	skill_node.skill_level = skill_level
	skill_node.skill_cost = skill_cost
	skill_node.upgrade_pressed.connect(on_upgrade_press)
		
	skill_container.add_child(skill_node)
	skill_map[upgrade_def.id] = skill_node
	
func create_module_buttons(missing_modules: Array[String], related_upgrade: UpgradeDefinition):
	prints("Creating module buttons for:", missing_modules)
	for module in missing_modules:
		# Skip if button exists
		if module_button_map.has(module):
			prints("Already in button map:", module)
			continue
		
		var module_def = upgrade_system.get_module_def(module)
		# See if module prerequisits fullfilled
		var prereqs_ok := true
		if module_def.required_modules.size() > 0:
			for req_module in module_def.required_modules:
				prints("module required:", req_module)
				if not upgrade_system.installed_modules[req_module]:
					prints("required module not installed:", req_module)
					prereqs_ok = false
					break
		if not prereqs_ok:
			continue
		
		# Find module's install cost
		if not module_def:
			prints("Module not found:", module)
			continue
	
		var button = create_module_unlock_button(module, module_def)
		if button:
			prints("Adding button for module:", module)
			module_container.add_child(button)
			module_button_map[module] = button
		else:
			prints("Failed to create button for module:", module)
func create_module_unlock_button(module_id: String, module_def: ModuleDefinition):
	prints("Looking for module:", module_id)
	prints("Available modules:", upgrade_system.modules.map(func(m): return m.id))
		
	var filtered = upgrade_system.modules.filter(func(m): return m.id == module_id)
		
	if filtered.is_empty():
			push_error("Module not found: " + module_id)
			return null
	
	module_def = filtered[0]
		
	var button = module_button_scene.instantiate()
	prints("instant button", button)
	button.button_id = module_id
	button.label_text = "Install " + module_def.display_name
	button.cost = module_def.install_cost
	button.pressed.connect(func(): _on_install_module_pressed(module_id, module_def.install_cost))
	return button

func on_upgrade_press(skill):
	var current_level = upgrade_system.get_level(skill.id)
	if upgrade_system.upgrade(skill):
		prints("upgraded! new level: ", upgrade_system.get_level(skill.id))
		var new_level = upgrade_system.get_level(skill.id)
		var skill_cost = upgrade_system.get_upgrade_cost(upgrade_system.get_def(skill.id), new_level)
		
		var _skill = skill_map[skill.id]
		if _skill:
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

func _on_install_module_pressed(module_id: String, cost):
	if upgrade_system.install_module(module_id, cost):
		update_skill_tree()
