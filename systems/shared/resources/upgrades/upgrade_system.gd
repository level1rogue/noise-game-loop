class_name UpgradeSystem
extends Resource

signal credits_changed
signal noise_changed
signal upgrade_done(upgrade_id: String, stat: float)
signal module_installed(module: String)

@export var database: UpgradeDatabase
@export var modules: Array[ModuleDefinition] = []

var installed_modules: Dictionary = {
	"sequencer": true,
	"effects_module": false,
	"delay_module": false,
	"reverb_module": false
}

var levels: Dictionary = {
	"shot_damage": 0,
	"shot_radius": 0,
	"effect_delay": 0,
	"effect_reverb": 0
	
} # [upgrade id] : [level]

var upgrade_strategies := {
	"effect_delay": PlayerDelayStrategy,
	"effect_reverb": PlayerShockwaveStrategy,
}

var applied_upgrades := {}

var credits: int = 1200
var noise: float = 0.0

func get_level(id:String) -> int:
	return levels.get(id, 0)
	
func get_def(id) -> UpgradeDefinition:
	for upgrade in database.upgrades:
		if upgrade.id == id:
			return upgrade

	return null
	
func get_module_def(id) -> ModuleDefinition:
	for module in modules:
		if module.id == id:
			return module
	return null
		
func get_stat(stat_id: String):
	var level = get_level(stat_id)
	var def = get_def(stat_id)
	if def:
		var current_stat = def.base_value + def.value_per_level * level
		return current_stat

func get_upgrade_cost(def: UpgradeDefinition, current_level: int):
	return def.base_cost + def.base_cost * def.cost_mult * current_level
	
func can_upgrade(def: UpgradeDefinition) -> bool:
	var current_level = levels[def.id]
	
	if current_level >= def.max_level:
		prints("Upgrade not possible: Max Level reached!")
		return false
	
	var actual_cost = get_upgrade_cost(def, current_level)
	
	if credits < actual_cost:
		prints("Upgrade not possible: Not enough credits! Needed:", actual_cost, "Available:", credits)
		return false
	
	return true

func upgrade(def: UpgradeDefinition) -> bool:
	if not can_upgrade(def):
		return false
	var current_level = levels[def.id]
	var actual_cost = get_upgrade_cost(def, current_level)
	on_subtract_credits(actual_cost)
	levels[def.id] += 1
	if upgrade_strategies.has(def.id):
		upgrade_strategies[def.id].apply_upgrade(levels[def.id])
	upgrade_done.emit(def.id, get_stat(def.id))
	return true
	
func get_all_upgrades() -> Array[UpgradeDefinition]:
	return database.upgrades

func update_special_upgrades(upgrade_type, is_applied):
	if is_applied:
		if not upgrade_type in applied_upgrades:
			applied_upgrades[upgrade_type] = upgrade_strategies[upgrade_type].new()
	else:
		if upgrade_type in applied_upgrades:
			applied_upgrades.erase(upgrade_type)
	

func install_module(module_id: String, cost: int):
	if credits >= cost:
		on_subtract_credits(cost)
		installed_modules[module_id] = true
		var module_def = get_module_def(module_id)
		if module_def.unlocks_upgrades.size() > 0:
			for unlock in module_def.unlocks_upgrades:
				if upgrade_strategies.has(unlock):
					update_special_upgrades(unlock, true)
		module_installed.emit(module_id)
		return true
	return false
				
func on_add_credits(_credits: int):
	credits += _credits
	credits_changed.emit()
	
func on_subtract_credits(_credits: int):
	credits -= _credits
	credits_changed.emit()
	
func on_noise_changed(_noise: int):	
	noise += _noise
	if noise >= GlobalData.DEADLY_NOISE_AMOUNT: noise = GlobalData.DEADLY_NOISE_AMOUNT
	noise_changed.emit()
	
func reset_all():
	noise = 0.0
	credits = 0
	
	for key in levels.keys():
		levels[key] = 0
