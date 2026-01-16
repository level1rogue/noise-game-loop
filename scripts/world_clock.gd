extends Node

@export var bpm := 120.0
@export var steps_per_beat := 4
@export var beats_per_bar := 4
@export var audio_player: AudioStreamPlayer

signal step(step_index: int)
signal beat(beat_index: int)
signal bar(bar_index: int)

var _seconds_per_beat: float
var _last_step := -1
var _last_beat := -1
var _last_bar := -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_seconds_per_beat = 60.0 / bpm
	#if audio_player:
		#audio_player.volume_db = -80.0 #NOTE: "Muted" for development; remove for prod!
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not audio_player or not audio_player.playing:
		return
	
	var song_time := (
		audio_player.get_playback_position()
		+ AudioServer.get_time_since_last_mix()
		- AudioServer.get_output_latency()
	)
	
	_update_time(song_time)

func _start_clock():
	if audio_player:
		audio_player.stop()
		audio_player.play()

func _update_time(time_sec: float):
	var beats_f = time_sec / _seconds_per_beat
	var steps_f = beats_f * steps_per_beat
	
	var step_i = int(floor(steps_f))
	var beat_i = int(floor(beats_f))
	var bar_i = int(floor(beats_f / beats_per_bar))
	
	if step_i != _last_step:
		_last_step = step_i
		step.emit(step_i)
		
	if beat_i != _last_beat:
		_last_beat = beat_i
		beat.emit(beat_i)
		
	if bar_i != _last_bar:
		_last_bar = bar_i
		#bar.emit(bar_i)
		
	
	
