extends Node

const DEADLY_NOISE_AMOUNT := 100.0

enum ModuleTypes {
	SEQUENCER,
	EFFECTS,
	MODULE_3,
	MODULE_4
}

var upgrade_system: UpgradeSystem

var polygon_outer_line: Polygon2D

func _ready():
		upgrade_system = load("res://entities/player/upgrades/upgrade_system.tres")
