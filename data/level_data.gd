extends Resource
class_name LevelData

@export var lvl_index: int
@export var duration: int # in bars

@export var polygon_sides: int
@export var polygon_sub_divs: int

@export var enemy_configs: Array[EnemySpawnConfig] = []
