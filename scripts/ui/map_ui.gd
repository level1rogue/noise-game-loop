extends Control

var lvl_positions : Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var levels = $LevelContainer/Levels.get_children()
	for lvl in levels:
		if lvl.global_position:
			prints("lvl: ", lvl)
			lvl_positions.append(lvl.global_position)
	draw_lines_between_levels()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func draw_lines_between_levels():
	prints("level positions:", lvl_positions)
