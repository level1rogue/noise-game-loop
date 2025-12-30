extends Node2D

var INIT_COUNT = 100
var init = true

var enemy = preload("res://scenes/enemy.tscn")

func _on_timer_timeout() -> void:
	if init:
		for i in INIT_COUNT:
			var en = enemy.instantiate()
			get_parent().add_child(en)
		init = false
	var en = enemy.instantiate()
	get_parent().add_child(en)
