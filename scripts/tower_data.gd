class_name TowerData
extends Resource

@export var tower_id: String = ""
@export var display_name: String = ""
@export var cost: int = 50
@export var attack_range: float = 10.0
@export var fire_rate: float = 1.0
@export var damage: float = 10.0
@export var damage_vs_infantry_mult: float = 1.0
@export var damage_vs_vehicle_mult: float = 1.0
@export var tower_scene: PackedScene
