extends Node

var LEVELS : Dictionary = {
	1: load("res://systems/game/world/level_manager/levels/level_1.tres"),
	2: load("res://systems/game/world/level_manager/levels/level_2.tres"),
	3: load("res://systems/game/world/level_manager/levels/level_3.tres"),
	4: load("res://systems/game/world/level_manager/levels/level_4.tres"),
	5: load("res://systems/game/world/level_manager/levels/level_5.tres"),
	6: load("res://systems/game/world/level_manager/levels/level_6.tres"),
}

var current_level_idx: int = 0
var current_level: LevelData

func load_next_level():
	current_level_idx += 1
	if current_level_idx > LEVELS.size():
		current_level_idx = 1
	current_level = LEVELS[current_level_idx]
	return current_level
	
func load_level(idx):
	current_level_idx = idx
	current_level = LEVELS[current_level_idx]
	return current_level
	
func get_current_level():
	return current_level
