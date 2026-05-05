class_name HUD
extends Control

@export var build_manager_path: NodePath

@onready var base_health_label: Label = $BaseHealthLabel
@onready var credits_label: Label = $CreditsLabel
@onready var wave_label: Label = $WaveLabel
@onready var enemies_remaining_label: Label = $EnemiesRemainingLabel
@onready var status_label: Label = $StatusLabel
@onready var build_hint_label: Label = $BuildHintLabel
@onready var tower_row: HBoxContainer = $TowerRow

var build_manager: BuildManager
var _selected_tower_data: TowerData = null


func _ready() -> void:
	GameState.state_changed.connect(_on_state_changed)
	GameState.wave_started.connect(_on_wave_started)
	GameState.wave_completed.connect(_on_wave_completed)
	GameState.base_health_changed.connect(_on_base_health_changed)
	GameState.enemies_remaining_changed.connect(_on_enemies_remaining_changed)
	GameState.credits_changed.connect(_on_credits_changed)
	if not build_manager_path.is_empty():
		build_manager = get_node_or_null(build_manager_path) as BuildManager
	if build_manager != null:
		build_manager.tower_selected_changed.connect(_on_tower_selected_changed)
	else:
		push_error("[HUD] build_manager could not be resolved from path: %s" % build_manager_path)
	call_deferred("_refresh_all")


func _refresh_all() -> void:
	_on_base_health_changed(GameState.base_current_health, GameState.base_max_health)
	_on_enemies_remaining_changed(GameState.enemies_remaining_in_wave)
	_on_credits_changed(GameState.credits)
	_refresh_wave_label()
	_refresh_status_label()
	_refresh_tower_labels()


func _on_base_health_changed(current: int, maximum: int) -> void:
	base_health_label.text = "Base: %d / %d" % [current, maximum]


func _on_enemies_remaining_changed(count: int) -> void:
	enemies_remaining_label.text = "Enemies: %d" % count


func _on_credits_changed(amount: int) -> void:
	credits_label.text = "Credits: %d" % amount
	_refresh_tower_labels()


func _on_state_changed(_new_state: int) -> void:
	_refresh_wave_label()
	_refresh_status_label()


func _on_wave_started(_wave_index: int, _total_waves: int) -> void:
	_refresh_wave_label()
	_refresh_status_label()


func _on_wave_completed(_wave_index: int) -> void:
	_refresh_status_label()


func _on_tower_selected_changed(td) -> void:
	_selected_tower_data = td
	_refresh_tower_labels()
	build_hint_label.visible = td != null
	if td != null:
		build_hint_label.text = "Left-click to place, Right-click or Esc to cancel"


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


func _refresh_tower_labels() -> void:
	if build_manager == null or tower_row == null:
		return
	var towers: Array[TowerData] = build_manager.available_towers
	for i in range(tower_row.get_child_count()):
		var label := tower_row.get_child(i) as Label
		if label == null:
			continue
		if i >= towers.size() or towers[i] == null:
			label.text = ""
			label.visible = false
			continue
		label.visible = true
		var td: TowerData = towers[i]
		label.text = "[%d] %s — %dc" % [i + 1, td.display_name, td.cost]
		if td == _selected_tower_data:
			label.modulate = Color(1.0, 1.0, 0.0)
		elif GameState.can_afford(td.cost):
			label.modulate = Color(1.0, 1.0, 1.0)
		else:
			label.modulate = Color(0.55, 0.55, 0.55)
