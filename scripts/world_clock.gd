extends Node

@export var bpm := 120.0
@export var steps_per_beat := 4
@export var beats_per_bar := 4
@export var audio_player: AudioStreamPlayer

var total_bars := 3
var total_count_in_beats := 4
var _is_count_in := false
var _is_playing := false

signal count_in_beat(count_in_index: int)
signal step(step_index: int)
signal beat(beat_index: int)
signal bar(bar_index: int)
signal level_started()
signal request_level_ended()

var _seconds_per_beat: float
var _last_count_in_beat := -1
var _last_step := -1
var _last_beat := -1
var _last_bar := -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bpm = self.bpm
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

func _start_count_in() -> void:
	_is_count_in = true
	_start_clock()

func _start_clock():
	#if not _is_count_in: _is_playing = true
	if audio_player:
		audio_player.stop()
		audio_player.play()
		
func _stop_clock():
	_is_playing = false
	if audio_player:
		audio_player.stop()

func _end_level():
	_stop_clock()
	request_level_ended.emit()

func _update_time(time_sec: float):
	
	var beats_f = time_sec / _seconds_per_beat
	var steps_f = beats_f * steps_per_beat
	
	if _is_count_in:
		var count_in_beat_i = int(floor(beats_f))
		if count_in_beat_i != _last_count_in_beat:
			if count_in_beat_i < total_count_in_beats:
				_last_count_in_beat = count_in_beat_i
				count_in_beat.emit(total_count_in_beats - count_in_beat_i)
			else:
				_is_count_in = false
				_is_playing = true
				audio_player.stop()
				audio_player.play()
				level_started.emit()
	elif _is_playing:
		
		var step_i = int(floor(steps_f))
		var beat_i = int(floor(beats_f))
		var bar_i = int(floor(beats_f / beats_per_bar))
		
		if bar_i >= total_bars:
			_end_level()
			return
		
		if step_i != _last_step:
			_last_step = step_i
			step.emit(step_i)
			
		if beat_i != _last_beat:
			_last_beat = beat_i
			beat.emit(beat_i)
			
		if bar_i != _last_bar:
			_last_bar = bar_i
			#bar.emit(bar_i)
			
func setup_level_and_start_clock(lvl: LevelData) -> void:
	total_bars = lvl.duration
	_start_count_in()
	prints("start count in")

func stop_level() -> void:
	_end_level()
