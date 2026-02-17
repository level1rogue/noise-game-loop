extends TextureRect

var icons: Dictionary = {
	"basic_shot": "res://assets/graphics/icons/sequencer_icons/shot_snipe_round.png",
	"sniper_shot": "res://assets/graphics/icons/sequencer_icons/shot_snipe_round.png",
	"bump_shot": "res://assets/graphics/icons/sequencer_icons/shot_bump.png",
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_icon(icon: String):
	if icons[icon]:
		texture = load(icons[icon])
