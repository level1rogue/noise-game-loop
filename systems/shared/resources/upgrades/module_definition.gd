class_name ModuleDefinition
extends Resource

@export var id: String
@export var display_name: String
@export var install_cost: int = 500
@export var description: String = ""

@export var unlocks_upgrades: Array[String]

@export var required_modules: Array[String]
