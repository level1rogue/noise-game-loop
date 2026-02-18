extends Control

@export var credits: Label
@export var damage: Label
@export var radius: Label

var _last_credits : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_stat(str(PlayerData.credits), "credits")
	set_stat(str(PlayerData.shot_damage), "damage")
	set_stat(str(PlayerData.shot_radius), "radius")

	_last_credits = PlayerData.credits

func set_stat(stat: String, type: String):
	match type:
		"credits":
			credits.text = stat
		"damage":
			damage.text = stat
		"radius":
			radius.text = stat

func on_credit_change():
	while PlayerData.credits - _last_credits > 0:		
		_last_credits += 1
		set_stat(str(_last_credits), "credits")
		await get_tree().create_timer(0.01).timeout
	set_stat(str(PlayerData.credits), "credits")
	
	_last_credits = PlayerData.credits
