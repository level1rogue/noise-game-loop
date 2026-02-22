class_name UpgradeSystem
extends Resource

signal credits_changed

@export var database: UpgradeDatabase

var levels: Dictionary = {
	"shot_damage_up": 0,
	"shot_radius_up": 0
	
} # [upgrade id] : [level]

var credits: int = 0

func get_level(id:String) -> int:
	return levels.get(id, 0)
	
func get_def(id) -> UpgradeDefinition:
	for upgrade in database.upgrades:
		if upgrade.id == id:
			return upgrade

	return null
	
func get_stat(stat: String):
	var stat_id = stat + "_up"
	var level = get_level(stat_id)
	var def = get_def(stat_id)
	prints("def: ", def)
	if def:
		var current_stat = def.base_value + def.value_per_level * level
		return current_stat
		
	
	
func can_upgrade(def: UpgradeDefinition, player_credits: int) -> bool:
	var current_level = levels[def.id]
	
	if current_level >= def.max_level:
		return false
	
	var actual_cost = def.base_cost + def.base_cost * def.cost_mult * current_level
	
	if player_credits < actual_cost:
		return false
	
	return true

func upgrade(def: UpgradeDefinition, player_credits: int) -> bool:
	if not can_upgrade(def, player_credits):
		return false
	var current_level = levels[def.id]
	var actual_cost = def.base_cost + def.base_cost * def.cost_mult * current_level
	on_subtract_credits(actual_cost)
	levels[def.id] += 1
	
	return true
	
func get_all_upgrades() -> Array[UpgradeDefinition]:
	return database.upgrades

				
func on_add_credits(_credits: int):
	credits += _credits
	credits_changed.emit()
	
func on_subtract_credits(_credits: int):
	credits -= _credits
	credits_changed.emit()
