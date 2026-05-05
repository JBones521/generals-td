class_name Enemy
extends CharacterBody3D

@export var move_speed: float = 4.0
@export var max_health: float = 30.0
@export var damage_on_reach_base: int = 1

var current_health: float
var _path: PathData
var _current_waypoint_index: int = 0
var _is_dying: bool = false


func _ready() -> void:
	current_health = max_health
	add_to_group("enemies")


func apply_wave_modifiers(health_mult: float, speed_mult: float) -> void:
	max_health = max_health * health_mult
	current_health = max_health
	move_speed = move_speed * speed_mult


func take_damage(amount: float) -> void:
	if _is_dying:
		return
	current_health -= amount
	if current_health <= 0.0:
		_is_dying = true
		GameState.on_enemy_killed()
		queue_free()


func assign_path(path: PathData) -> void:
	_path = path
	_current_waypoint_index = 0
	if path != null and path.waypoints.size() > 0:
		var start := path.waypoints[0]
		start.y = 1.0
		if global_position.distance_to(start) > 0.1:
			global_position = start


func _physics_process(delta: float) -> void:
	if _is_dying:
		return
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
	if _is_dying:
		return
	_is_dying = true
	GameState.on_enemy_reached_base(damage_on_reach_base)
	GameState.on_enemy_killed()
	queue_free()
