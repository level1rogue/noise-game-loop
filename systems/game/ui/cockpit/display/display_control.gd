extends Control

@export var upgrade_system: UpgradeSystem

@export var credits: Label
@export var damage: Label
@export var radius: Label

var _last_credits : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	upgrade_system.credits_changed.connect(on_credit_change)
	
	set_stat(str(upgrade_system.credits), "credits")
	set_stat(str(upgrade_system.get_stat("shot_damage")), "damage")
	set_stat(str(upgrade_system.get_stat("shot_radius")), "radius")

	_last_credits = upgrade_system.credits

func set_stat(stat: String, type: String):
	match type:
		"credits":
			credits.text = stat
		"damage":
			damage.text = stat
		"radius":
			radius.text = stat

func on_credit_change(): #TODO: add functionality for subtracting credit (use tweens instead!)
	%CreditsLabel.credits = upgrade_system.credits
	#TODO: Find better (working!) way to set the stats after upgrade!
	set_stat(str(upgrade_system.get_stat("shot_damage")), "damage")
	set_stat(str(upgrade_system.get_stat("shot_radius")), "radius")
