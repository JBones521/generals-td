class_name PathData
extends Resource

@export var path_name: String = ""
@export var waypoints: PackedVector3Array = []
@export var debug_color: Color = Color.YELLOW


func get_total_length() -> float:
	var total: float = 0.0
	for i in range(1, waypoints.size()):
		total += waypoints[i - 1].distance_to(waypoints[i])
	return total
