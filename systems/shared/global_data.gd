extends Node

var upgrade_system: UpgradeSystem

func _ready():
		upgrade_system = load("res://entities/player/upgrades/upgrade_system.tres")
