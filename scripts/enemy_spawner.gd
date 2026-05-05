class_name EnemySpawner
extends Node3D

@export var available_paths: Array[PathData] = []


func spawn_enemy(enemy_data: EnemyData, path: PathData, health_mult: float = 1.0, speed_mult: float = 1.0) -> void:
	if enemy_data == null:
		push_error("[EnemySpawner] enemy_data is null — cannot spawn")
		return
	if enemy_data.enemy_scene == null:
		push_error("[EnemySpawner] enemy_data.enemy_scene is null — cannot spawn")
		return
	if path == null:
		push_error("[EnemySpawner] path is null — cannot spawn")
		return
	if path.waypoints.size() == 0:
		push_error("[EnemySpawner] path '%s' has no waypoints — cannot spawn" % path.path_name)
		return
	var enemy := enemy_data.enemy_scene.instantiate() as Enemy
	if enemy == null:
		push_error("[EnemySpawner] failed to cast instantiated scene to Enemy")
		return
	enemy.enemy_data = enemy_data
	var start_position: Vector3 = path.waypoints[0]
	start_position.y = 1.0
	enemy.position = start_position
	get_parent().add_child(enemy)
	enemy.apply_wave_modifiers(health_mult, speed_mult)
	enemy.assign_path(path)
	print("[EnemySpawner] spawned %s on '%s' (h_mult=%.2f s_mult=%.2f) at %s" % [enemy_data.enemy_id, path.path_name, health_mult, speed_mult, enemy.global_position])
