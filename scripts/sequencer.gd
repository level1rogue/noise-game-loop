extends Control

const BEATS_PER_BAR := 4
const STEPS_PER_BEAT := 4
const STEPS_PER_BAR := BEATS_PER_BAR * STEPS_PER_BEAT

var seq_step : int = 0
var seq_beat : int = 0
var seq_bar : int = 0

var display_step : int
var display_beat : int
var display_bar : int

var all_steps : Array[StepPad] = []

var step_pad = preload("res://scenes/step_pad.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if %SequencerGrid:
		for i in STEPS_PER_BAR:
			var pad = step_pad.instantiate()
			pad.step_index = i
			if i % 4 == 0:
				pad.set_highlight(true)
			%SequencerGrid.add_child(pad)
			all_steps.append(pad)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# called by World Clock signal
func on_step_progress(step: int):
	#prints("step progress", step)
	var step_in_bar = step % STEPS_PER_BAR
	seq_step = step_in_bar
	seq_beat = (step_in_bar / STEPS_PER_BEAT)
	seq_bar  = step / STEPS_PER_BAR
	display_step = seq_step + 1
	display_beat = seq_beat + 1
	display_bar = seq_bar + 1
	if all_steps[step_in_bar]:
		all_steps[step_in_bar].set_active(true)
		if step_in_bar > 0:
			all_steps[step_in_bar - 1].set_active(false)
		else:
			all_steps[STEPS_PER_BAR - 1].set_active(false)

func on_beat_progress(beat: int):
	if %BPMIndicator: %BPMIndicator.on_beat(beat)

func set_initial_seq_steps(data):
	for step in data:
		if all_steps[step]:
			all_steps[step].set_icon(data[step])
