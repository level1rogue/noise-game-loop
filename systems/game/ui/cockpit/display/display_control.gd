extends Control


@export var credits: Label
@export var damage: Label
@export var radius: Label

@onready var upgrade_system: UpgradeSystem = GlobalData.upgrade_system

var _last_credits : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	upgrade_system.credits_changed.connect(on_credit_change)
	upgrade_system.upgrade_done.connect(on_update_done)
	
	#%DustContainer/Icon.set_icon("dust", "small")
	
	set_stat(str(upgrade_system.credits), "credits")
	set_stat(str(upgrade_system.get_stat("shot_damage")), "shot_damage")
	set_stat(str(upgrade_system.get_stat("shot_radius")), "shot_radius")

	_last_credits = upgrade_system.credits

func set_stat(stat: String, type: String):
	match type:
		"credits":
			credits.text = stat
		"shot_damage":
			damage.text = stat
		"shot_radius":
			radius.text = stat

func on_credit_change(): #TODO: add functionality for subtracting credit (use tweens instead!)
	%CreditsLabel.units = upgrade_system.credits
	#TODO: Find better (working!) way to set the stats after upgrade!
	

func on_update_done(id: String, stat: float):
	set_stat(str(stat), id)

	
