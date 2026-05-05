class_name WaveData
extends Resource

@export var enemy_scene: PackedScene
@export var enemy_count: int = 5
@export var spawn_interval: float = 1.0
@export var enemy_health_multiplier: float = 1.0
@export var enemy_speed_multiplier: float = 1.0
@export var paths_to_use: Array[PathData] = []
@export var damage_to_base: int = 1
