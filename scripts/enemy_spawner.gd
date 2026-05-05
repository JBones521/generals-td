class_name EnemySpawner
extends Node3D

@export var enemy_scene: PackedScene
@export var available_paths: Array[PathData] = []


func spawn_enemy(path: PathData, health_mult: float = 1.0, speed_mult: float = 1.0, damage_to_base: int = 1) -> void:
	if enemy_scene == null:
		push_error("[EnemySpawner] enemy_scene is null — cannot spawn")
		return
	if path == null:
		push_error("[EnemySpawner] path is null — cannot spawn")
		return
	var enemy := enemy_scene.instantiate() as Enemy
	if enemy == null:
		push_error("[EnemySpawner] failed to cast instantiated scene to Enemy")
		return
	get_parent().add_child(enemy)
	enemy.apply_wave_modifiers(health_mult, speed_mult)
	enemy.damage_on_reach_base = damage_to_base
	enemy.assign_path(path)
	print("[EnemySpawner] spawned enemy on '%s' (h_mult=%.2f s_mult=%.2f dmg=%d) at %s" % [path.path_name, health_mult, speed_mult, damage_to_base, enemy.global_position])
