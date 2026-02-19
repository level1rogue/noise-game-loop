extends Node2D

var loaded_level: LevelData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	$World.on_load_next_level.connect(load_next_level)
	$World.on_level_ended.connect(_on_level_ended)
	
	$World/WorldClock.step.connect($HUDLayer/CockpitLayer/%Sequencer.on_step_progress)
	$World/WorldClock.beat.connect($HUDLayer/CockpitLayer/%Sequencer.on_beat_progress)
	$World/WorldClock.bar.connect($HUDLayer/CockpitLayer/%Sequencer.on_bar_progress)
	
	$HUDLayer/CockpitLayer.start_level.connect($World._on_start_requested)
	#$HUDLayer/CockpitLayer.load_next_level.connect(load_next_level )
	
	$World.on_set_initial_seq_steps.connect($HUDLayer/CockpitLayer/%Sequencer.set_initial_seq_steps)
	
	$World.on_count_in.connect($HUDLayer.on_count_in)
	
	$World/EnemySpawnMachine.on_add_to_credits.connect(on_credit_change)
	#$World/EnemySpawnMachine.on_add_to_credits.connect($HUDLayer/CockpitLayer/%DisplayControl.on_credit_change)
	

func _on_toggle_pause(button: Button):
	if get_tree().paused:
		get_tree().paused = false
		button.text = "Pause"
	else:
		get_tree().paused = true
		button.text = "Resume"

func load_next_level(level: LevelData):
	$HUDLayer/CockpitLayer/%Sequencer.set_initial_bars(level.duration)
	loaded_level = level
	
func _on_level_ended():
	$HUDLayer/CockpitLayer/%Sequencer.set_finished()
	$HUDLayer/RewardScreen.set_level_rewards(loaded_level)

func on_credit_change(amount: int):
	$World/%Player.on_credit_change(amount)
	$HUDLayer/CockpitLayer/%DisplayControl.on_credit_change()	
	
		
