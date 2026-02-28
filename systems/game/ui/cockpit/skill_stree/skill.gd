extends Control

signal upgrade_pressed(id: String, audio_player: AudioStreamPlayer)

var skill: UpgradeDefinition
var skill_level: int
var skill_cost: int

func _ready() -> void:
	%NameLabel.text = skill.display_name
	update_ui()
	
func update_ui():
	%LevelLabel.text = str(skill_level)
	%MaxLevelLabel.text = " of " + str(skill.max_level)
	%CostLabel.text = str(skill_cost)

func _on_upgrade_button_pressed() -> void:
	upgrade_pressed.emit(skill, $AudioUpgradeButton)
