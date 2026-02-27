class_name UpgradeDefinition
extends Resource

@export var id: String
@export var display_name: String
@export var skill_ref: String

@export var max_level: int

@export var base_cost: int = 100
@export var cost_mult: float = 1.5

@export var base_value: float
@export var value_per_level: float

@export var required_modules: Array[String]
#TODO: Add upgrade requirements
#@export var required_upgrades: Array[UpgradeRequirement]
