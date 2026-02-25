extends Node

const DEADLY_NOISE_AMOUNT := 100.0

var upgrade_system: UpgradeSystem

var polygon_outer_line: Polygon2D

func _ready():
		upgrade_system = load("res://entities/player/upgrades/upgrade_system.tres")
