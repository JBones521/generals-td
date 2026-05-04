@tool
class_name Tower
extends Node3D

@export var tower_name: String = "Basic Tower"

@export var attack_range: float = 10.0:
	set(value):
		attack_range = value
		_update_range_indicator()

@export var fire_rate: float = 1.0
@export var damage: float = 10.0

@export var show_range_indicator: bool = true:
	set(value):
		show_range_indicator = value
		_update_range_indicator()


func _ready() -> void:
	_update_range_indicator()


func _update_range_indicator() -> void:
	if not is_inside_tree():
		return
	var indicator := get_node_or_null("RangeIndicator") as MeshInstance3D
	if indicator == null:
		return
	indicator.visible = show_range_indicator
	var torus := indicator.mesh as TorusMesh
	if torus == null:
		return
	torus.outer_radius = attack_range
	torus.inner_radius = max(attack_range - 0.1, 0.0)
