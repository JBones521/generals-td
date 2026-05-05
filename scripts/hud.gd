class_name HUD
extends Control

@onready var base_health_label: Label = $BaseHealthLabel
@onready var wave_label: Label = $WaveLabel
@onready var enemies_remaining_label: Label = $EnemiesRemainingLabel
@onready var status_label: Label = $StatusLabel


func _ready() -> void:
	GameState.state_changed.connect(_on_state_changed)
	GameState.wave_started.connect(_on_wave_started)
	GameState.wave_completed.connect(_on_wave_completed)
	GameState.base_health_changed.connect(_on_base_health_changed)
	GameState.enemies_remaining_changed.connect(_on_enemies_remaining_changed)
	call_deferred("_refresh_all")


func _refresh_all() -> void:
	_on_base_health_changed(GameState.base_current_health, GameState.base_max_health)
	_on_enemies_remaining_changed(GameState.enemies_remaining_in_wave)
	_refresh_wave_label()
	_refresh_status_label()


func _on_base_health_changed(current: int, maximum: int) -> void:
	base_health_label.text = "Base: %d / %d" % [current, maximum]


func _on_enemies_remaining_changed(count: int) -> void:
	enemies_remaining_label.text = "Enemies: %d" % count


func _on_state_changed(_new_state: int) -> void:
	_refresh_wave_label()
	_refresh_status_label()


func _on_wave_started(_wave_index: int, _total_waves: int) -> void:
	_refresh_wave_label()
	_refresh_status_label()


func _on_wave_completed(_wave_index: int) -> void:
	_refresh_status_label()


func _refresh_wave_label() -> void:
	var total: int = GameState.total_waves
	if GameState.current_state == GameState.State.PRE_GAME or GameState.current_wave_index < 0:
		wave_label.text = "Wave: - / %d" % total
	else:
		wave_label.text = "Wave: %d / %d" % [GameState.current_wave_index + 1, total]


func _refresh_status_label() -> void:
	match GameState.current_state:
		GameState.State.PRE_GAME:
			status_label.text = "Press N to start Wave 1"
			status_label.visible = true
		GameState.State.WAVE_ACTIVE:
			status_label.visible = false
		GameState.State.WAVE_COMPLETE:
			status_label.text = "Wave %d complete. Press N for next wave." % (GameState.current_wave_index + 1)
			status_label.visible = true
		GameState.State.VICTORY:
			status_label.text = "VICTORY! All waves cleared."
			status_label.visible = true
		GameState.State.DEFEAT:
			status_label.text = "DEFEAT. Your base has fallen."
			status_label.visible = true
