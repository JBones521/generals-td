class_name WaveData
extends Resource

@export var groups: Array[WaveGroup] = []
@export var enemy_health_multiplier: float = 1.0
@export var enemy_speed_multiplier: float = 1.0
@export var paths_to_use: Array[PathData] = []


func get_total_count() -> int:
	var total: int = 0
	for g in groups:
		if g != null:
			total += g.count
	return total


func get_summary() -> String:
	var parts: Array = []
	for g in groups:
		if g == null or g.enemy_data == null:
			continue
		parts.append("%d %s" % [g.count, g.enemy_data.display_name])
	if parts.is_empty():
		return ""
	if parts.size() == 1:
		return parts[0]
	return "Mixed: " + " + ".join(parts)
