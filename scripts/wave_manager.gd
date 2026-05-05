class_name WaveManager
extends Node

@export var level_waves: LevelWaves
@export var spawner: EnemySpawner


func _ready() -> void:
	if level_waves != null:
		GameState.total_waves = level_waves.waves.size()
	GameState.wave_started.connect(_on_wave_started)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_N:
		if GameState.current_state == GameState.State.PRE_GAME or GameState.current_state == GameState.State.WAVE_COMPLETE:
			GameState.start_next_wave()


func _on_wave_started(wave_index: int, _total_waves: int) -> void:
	if level_waves == null:
		return
	if wave_index < 0 or wave_index >= level_waves.waves.size():
		return
	var wave: WaveData = level_waves.waves[wave_index]
	if wave == null:
		return
	GameState.enemies_remaining_in_wave = wave.enemy_count
	GameState.enemies_remaining_changed.emit(wave.enemy_count)
	_spawn_wave(wave)


func _spawn_wave(wave: WaveData) -> void:
	if spawner == null:
		return
	var paths: Array[PathData] = wave.paths_to_use
	if paths.is_empty():
		paths = spawner.available_paths
	if paths.is_empty():
		return
	for i in range(wave.enemy_count):
		if not is_inside_tree():
			return
		var path := paths[i % paths.size()]
		spawner.spawn_enemy(path, wave.enemy_health_multiplier, wave.enemy_speed_multiplier, wave.damage_to_base)
		if i < wave.enemy_count - 1:
			await get_tree().create_timer(wave.spawn_interval).timeout
