class_name UpgradeSystem
extends Resource

signal credits_changed
signal noise_changed
signal upgrade_done(upgrade_id: String, stat: float)

@export var database: UpgradeDatabase

var levels: Dictionary = {
	"shot_damage": 0,
	"shot_radius": 0
	
} # [upgrade id] : [level]

var credits: int = 0
var noise: float = 0.0

func get_level(id:String) -> int:
	return levels.get(id, 0)
	
func get_def(id) -> UpgradeDefinition:
	for upgrade in database.upgrades:
		if upgrade.id == id:
			return upgrade

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
	upgrade_done.emit(def.id, get_stat(def.id))
	return true
	
func get_all_upgrades() -> Array[UpgradeDefinition]:
	return database.upgrades

				
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
