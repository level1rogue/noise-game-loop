extends TextureRect
class_name Icon

@export var icon_to_set: String
@export var size_to_set: String
#
#enum default_sizes {
	#SMALL, MEDIUM, BIG
#}

var icons: Dictionary = {
	# general
	"dust": "res://assets/graphics/icons/general/currency_dust.png",
	# weapons
	"basic_shot": "res://assets/graphics/icons/sequencer_icons/shot_snipe_round.png",
	"sniper_shot": "res://assets/graphics/icons/sequencer_icons/shot_snipe_round.png",
	"bump_shot": "res://assets/graphics/icons/sequencer_icons/shot_bump.png",
}

var sizes := {
	"small": 28,
	"medium": 48,
	"big": 128
}

func _ready() -> void:
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	
	if icon_to_set != "" and size_to_set != "":
		set_icon(icon_to_set, size_to_set)

func set_icon(icon: String, _size: String = "medium"):
	if icons[icon]:
		texture = load(icons[icon])
		prints("icon size", _size)
		var px = sizes[_size]
		custom_minimum_size = Vector2(px, px)
