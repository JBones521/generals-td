class_name Enemy
extends CharacterBody3D

@export var enemy_data: EnemyData
@export var move_speed: float = 4.0
@export var max_health: float = 30.0
@export var damage_on_reach_base: int = 1

var enemy_type: String = "vehicle"
var current_health: float
var _path: PathData
var _current_waypoint_index: int = 0
var _is_dying: bool = false


func _ready() -> void:
	if enemy_data != null:
		max_health = enemy_data.max_health
		move_speed = enemy_data.move_speed
		damage_on_reach_base = enemy_data.damage_to_base
		enemy_type = enemy_data.enemy_type
	current_health = max_health
	motion_mode = CharacterBody3D.MOTION_MODE_FLOATING
	add_to_group("enemies")


func apply_wave_modifiers(health_mult: float, speed_mult: float) -> void:
	max_health = max_health * health_mult
	current_health = max_health
	move_speed = move_speed * speed_mult


func take_damage(amount: float) -> void:
	if _is_dying:
		return
	current_health -= amount
	print("[Enemy] ", name, " took ", amount, " damage. HP now ", current_health, "/", max_health, " at ", global_position)
	_update_health_bar()
	if current_health <= 0.0:
		_is_dying = true
		if enemy_data != null:
			GameState.add_credits(enemy_data.bounty)
		GameState.on_enemy_killed()
		queue_free()


func _update_health_bar() -> void:
	var bar := get_node_or_null("HealthBar") as Node3D
	if bar == null:
		return
	var fg := bar.get_node_or_null("Foreground") as MeshInstance3D
	if fg == null:
		return
	var ratio: float = clamp(current_health / max_health, 0.0, 1.0) if max_health > 0.0 else 0.0
	fg.scale.x = max(ratio, 0.0001)
	fg.position.x = (ratio - 1.0) * 0.5
	bar.visible = ratio < 1.0


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

	if Engine.get_physics_frames() % 60 == 0:
		var target_str: String
		if _current_waypoint_index < _path.waypoints.size():
			target_str = str(_path.waypoints[_current_waypoint_index])
		else:
			target_str = "OOB"
		print("[Enemy] ", name, " pos=", global_position, " target_idx=", _current_waypoint_index, " target=", target_str, " path='", _path.path_name, "'")

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
	else:
		var direction := to_target / distance
		velocity = direction * move_speed
		velocity.y = 0.0
		move_and_slide()

	global_position.y = 1.0


func _on_path_completed() -> void:
	if _is_dying:
		return
	_is_dying = true
	GameState.on_enemy_reached_base(damage_on_reach_base)
	GameState.on_enemy_killed()
	queue_free()
