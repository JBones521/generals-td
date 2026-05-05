class_name WaveManager
extends Node

@export var level_waves: LevelWaves
@export var spawner_path: NodePath = NodePath("../EnemySpawner")

var spawner: EnemySpawner


func _ready() -> void:
	if not spawner_path.is_empty():
		spawner = get_node_or_null(spawner_path) as EnemySpawner
	if spawner == null:
		push_error("[WaveManager] spawner could not be resolved from path: %s" % spawner_path)
	if level_waves == null:
		push_error("[WaveManager] level_waves is not assigned")
	else:
		GameState.total_waves = level_waves.waves.size()
	GameState.wave_started.connect(_on_wave_started)
	print("[WaveManager] _ready — spawner=%s, level_waves=%s, total_waves=%d" % [spawner, level_waves, GameState.total_waves])


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_N:
		if GameState.current_state == GameState.State.PRE_GAME or GameState.current_state == GameState.State.WAVE_COMPLETE:
			GameState.start_next_wave()


func _on_wave_started(wave_index: int, _total_waves: int) -> void:
	print("[WaveManager] wave_started signal received: wave_index=%d" % wave_index)
	if level_waves == null:
		push_error("[WaveManager] cannot start wave: level_waves is null")
		return
	if wave_index < 0 or wave_index >= level_waves.waves.size():
		push_error("[WaveManager] wave_index %d out of range (size=%d)" % [wave_index, level_waves.waves.size()])
		return
	var wave: WaveData = level_waves.waves[wave_index]
	if wave == null:
		push_error("[WaveManager] wave at index %d is null" % wave_index)
		return
	GameState.enemies_remaining_in_wave = wave.enemy_count
	GameState.enemies_remaining_changed.emit(wave.enemy_count)
	print("[WaveManager] starting wave %d: count=%d interval=%.2fs h_mult=%.2f s_mult=%.2f" % [wave_index + 1, wave.enemy_count, wave.spawn_interval, wave.enemy_health_multiplier, wave.enemy_speed_multiplier])
	_spawn_wave(wave)


func _spawn_wave(wave: WaveData) -> void:
	if spawner == null:
		push_error("[WaveManager] cannot spawn — spawner is null")
		return
	var paths: Array[PathData] = wave.paths_to_use
	if paths.is_empty():
		print("[WaveManager] wave.paths_to_use empty, falling back to spawner.available_paths")
		paths = spawner.available_paths
	if paths.is_empty():
		push_error("[WaveManager] cannot spawn — no paths available")
		return
	print("[WaveManager] spawning %d enemies across %d paths" % [wave.enemy_count, paths.size()])
	for i in range(wave.enemy_count):
		if not is_inside_tree():
			print("[WaveManager] aborting spawn loop — manager left tree")
			return
		var path := paths[i % paths.size()]
		print("[WaveManager] spawn %d/%d on path '%s'" % [i + 1, wave.enemy_count, path.path_name if path != null else "<null>"])
		spawner.spawn_enemy(path, wave.enemy_health_multiplier, wave.enemy_speed_multiplier, wave.damage_to_base)
		if i < wave.enemy_count - 1:
			await get_tree().create_timer(wave.spawn_interval).timeout
	print("[WaveManager] spawn loop complete for this wave")
