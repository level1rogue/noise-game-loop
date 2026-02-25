extends Node2D

@export var upgrade_system: UpgradeSystem

var loaded_level: LevelData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#_on_game_over()
	$World.on_load_next_level.connect(load_next_level)
	$World.on_level_ended.connect(_on_level_ended)
	
	$World/WorldClock.step.connect($HUDLayer/CockpitLayer/%Sequencer.on_step_progress)
	$World/WorldClock.beat.connect($HUDLayer/CockpitLayer/%Sequencer.on_beat_progress)
	$World/WorldClock.bar.connect($HUDLayer/CockpitLayer/%Sequencer.on_bar_progress)
	
	$HUDLayer/CockpitLayer.start_level.connect($World._on_start_requested)
	$HUDLayer/CockpitLayer.load_next_level.connect(_request_load_next_level)
	
	$World.on_set_initial_seq_steps.connect($HUDLayer/CockpitLayer/%Sequencer.set_initial_seq_steps)
	
	$World.on_count_in.connect($HUDLayer.on_count_in)
	
	$World/EnemySpawnMachine.on_add_to_credits.connect(on_credit_change)
	#$World/EnemySpawnMachine.on_add_to_credits.connect($HUDLayer/CockpitLayer/%DisplayControl.on_credit_change)
	$World.game_over.connect(_on_game_over)

	$GameOverScreen.request_restart.connect(_on_game_restart)

	_request_load_next_level()
func _on_toggle_pause(button: Button):
	if get_tree().paused:
		get_tree().paused = false
		button.text = "Pause"
	else:
		get_tree().paused = true
		button.text = "Resume"

func _request_load_next_level():
	$World.load_next_level()

func load_next_level(level: LevelData):
	prints("hello next level")
	$HUDLayer/CockpitLayer/%Sequencer.set_initial_bars(level.duration)
	$HUDLayer/CockpitLayer/%LevelInfoControl.level_info = level.lvl_info
	$HUDLayer/CockpitLayer/%LevelInfoControl.fade_in()
	loaded_level = level
	
func _on_level_ended():
	$HUDLayer/CockpitLayer/%Sequencer.set_finished()
	#$HUDLayer/RewardScreen.set_level_rewards(loaded_level)
	$HUDLayer/CockpitLayer.toggle_skill_tree()

func on_credit_change(amount: int):
	$HUDLayer/CockpitLayer/SkillTree.on_add_credits(amount)
	$HUDLayer/CockpitLayer/%DisplayControl.on_credit_change()	
	
func _on_game_over():
	await get_tree().create_timer(1.2).timeout
	get_tree().paused = true
	var game_over_screen = $GameOverScreen
	var game_over_control = $GameOverScreen/GameOverControl
	game_over_control.modulate.a = 0.0
	game_over_screen.visible = true
	var tween = create_tween()
	tween.tween_property(game_over_control, "modulate:a", 1.0, 1.0)

func _on_game_restart():
	get_tree().paused = false
	upgrade_system.reset_all()
	get_tree().reload_current_scene()
