class_name Enemy
extends CharacterBody3D

@export var move_speed: float = 4.0
@export var max_health: float = 30.0

var current_health: float
var _path: PathData
var _current_waypoint_index: int = 0


func _ready() -> void:
	current_health = max_health
	add_to_group("enemies")


func take_damage(amount: float) -> void:
	current_health -= amount
	if current_health <= 0.0:
		queue_free()


func assign_path(path: PathData) -> void:
	_path = path
	_current_waypoint_index = 0
	if path != null and path.waypoints.size() > 0:
		var start := path.waypoints[0]
		start.y = 1.0
		global_position = start


func _physics_process(delta: float) -> void:
	if _path == null:
		return
	if _current_waypoint_index >= _path.waypoints.size():
		return

	var target := _path.waypoints[_current_waypoint_index]
	target.y = 1.0
	var to_target := target - global_position
	var distance := to_target.length()

	if distance < move_speed * delta:
		global_position = target
		velocity = Vector3.ZERO
		_current_waypoint_index += 1
		if _current_waypoint_index >= _path.waypoints.size():
			_on_path_completed()
		return

	var direction := to_target / distance
	velocity = direction * move_speed
	move_and_slide()


func _on_path_completed() -> void:
	queue_free()
