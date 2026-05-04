class_name EnemySpawner
extends Node3D

@export var enemy_scene: PackedScene
@export var available_paths: Array[PathData] = []


func spawn_enemy() -> void:
	if enemy_scene == null or available_paths.is_empty():
		return
	var path: PathData = available_paths.pick_random()
	var enemy := enemy_scene.instantiate()
	get_parent().add_child(enemy)
	enemy.assign_path(path)
	print("Spawned enemy on path: ", path.path_name)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_SPACE:
		spawn_enemy()
