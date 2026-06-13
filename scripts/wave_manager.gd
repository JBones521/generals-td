class_name WaveManager
extends Node

const COUNTDOWN_DURATION: float = 20.0
const EARLY_START_BONUS: int = 25

signal countdown_changed(seconds_remaining: float)

@export var level_waves: LevelWaves
@export var spawner_path: NodePath = NodePath("../EnemySpawner")

var spawner: EnemySpawner

var _countdown_remaining: float = 0.0


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
	GameState.wave_completed.connect(_on_wave_completed)
	if GameState.DEBUG_LOGGING:
		print("[WaveManager] _ready — spawner=%s, level_waves=%s, total_waves=%d" % [spawner, level_waves, GameState.total_waves])


func _process(delta: float) -> void:
	if _countdown_remaining <= 0.0:
		return
	if GameState.current_state != GameState.State.WAVE_COMPLETE:
		_countdown_remaining = 0.0
		countdown_changed.emit(0.0)
		return
	_countdown_remaining -= delta
	if _countdown_remaining <= 0.0:
		_countdown_remaining = 0.0
		countdown_changed.emit(0.0)
		if GameState.DEBUG_LOGGING:
			print("[WaveManager] countdown expired, auto-starting next wave")
		GameState.start_next_wave()
	else:
		countdown_changed.emit(_countdown_remaining)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_N:
		if GameState.current_state == GameState.State.PRE_GAME:
			GameState.start_next_wave()
		elif GameState.current_state == GameState.State.WAVE_COMPLETE:
			if _countdown_remaining > 0.0:
				GameState.add_credits(EARLY_START_BONUS)
				GameState.early_start_bonus += EARLY_START_BONUS
				if GameState.DEBUG_LOGGING:
					print("[WaveManager] early start bonus: +%d credits (total bonus this run: %d)" % [EARLY_START_BONUS, GameState.early_start_bonus])
				_countdown_remaining = 0.0
				countdown_changed.emit(0.0)
			GameState.start_next_wave()
	elif event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_R:
		if GameState.current_state == GameState.State.VICTORY or GameState.current_state == GameState.State.DEFEAT:
			GameState.reset_game()
			get_tree().reload_current_scene()


func _on_wave_started(wave_index: int, _total_waves: int) -> void:
	if GameState.DEBUG_LOGGING:
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
	var total: int = wave.get_total_count()
	GameState.enemies_remaining_in_wave = total
	GameState.enemies_remaining_changed.emit(total)
	if GameState.DEBUG_LOGGING:
		print("[WaveManager] starting wave %d: %s (total=%d, h_mult=%.2f, s_mult=%.2f)" % [wave_index + 1, wave.get_summary(), total, wave.enemy_health_multiplier, wave.enemy_speed_multiplier])
	_spawn_wave(wave)


func _on_wave_completed(_wave_index: int) -> void:
	if GameState.current_state == GameState.State.WAVE_COMPLETE:
		_countdown_remaining = COUNTDOWN_DURATION
		countdown_changed.emit(_countdown_remaining)
		if GameState.DEBUG_LOGGING:
			print("[WaveManager] starting %d-second pre-wave countdown" % int(COUNTDOWN_DURATION))


func _spawn_wave(wave: WaveData) -> void:
	if spawner == null:
		push_error("[WaveManager] cannot spawn — spawner is null")
		return
	if wave.groups.is_empty():
		push_error("[WaveManager] wave has no groups — cannot spawn")
		return
	var paths: Array[PathData] = wave.paths_to_use
	if paths.is_empty():
		paths = spawner.available_paths
	if paths.is_empty():
		push_error("[WaveManager] cannot spawn — no paths available")
		return
	var path_index: int = 0
	for group_index in range(wave.groups.size()):
		var group: WaveGroup = wave.groups[group_index]
		if group == null or group.enemy_data == null:
			push_error("[WaveManager] wave group %d has no enemy_data — skipping" % group_index)
			continue
		if GameState.DEBUG_LOGGING:
			print("[WaveManager] group %d/%d: %d × %s, interval=%.2fs, delay_after=%.2fs" % [group_index + 1, wave.groups.size(), group.count, group.enemy_data.enemy_id, group.interval, group.delay_after])
		for i in range(group.count):
			if not is_inside_tree():
				return
			var path := paths[path_index % paths.size()]
			path_index += 1
			spawner.spawn_enemy(group.enemy_data, path, wave.enemy_health_multiplier, wave.enemy_speed_multiplier)
			if i < group.count - 1:
				await get_tree().create_timer(group.interval).timeout
				if GameState.current_state == GameState.State.DEFEAT or GameState.current_state == GameState.State.VICTORY:
					return
		if group.delay_after > 0.0 and group_index < wave.groups.size() - 1:
			await get_tree().create_timer(group.delay_after).timeout
			if GameState.current_state == GameState.State.DEFEAT or GameState.current_state == GameState.State.VICTORY:
				return
	if GameState.DEBUG_LOGGING:
		print("[WaveManager] spawn loop complete for this wave")
