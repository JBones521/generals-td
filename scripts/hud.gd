class_name HUD
extends Control

@export var build_manager_path: NodePath
@export var wave_manager_path: NodePath

@onready var base_health_label: Label = $BaseHealthLabel
@onready var credits_label: Label = $CreditsLabel
@onready var income_label: Label = $IncomeLabel
@onready var wave_label: Label = $WaveLabel
@onready var enemies_remaining_label: Label = $EnemiesRemainingLabel
@onready var status_label: Label = $StatusLabel
@onready var build_hint_label: Label = $BuildHintLabel
@onready var next_wave_label: Label = $NextWaveLabel
@onready var tower_row: HBoxContainer = $TowerRow

var build_manager: BuildManager
var wave_manager: WaveManager

var _selected_tower_data: PlaceableData = null
var _countdown_remaining: float = 0.0


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
		build_manager.buildings_changed.connect(_on_buildings_changed)
	else:
		push_error("[HUD] build_manager could not be resolved from path: %s" % build_manager_path)
	if not wave_manager_path.is_empty():
		wave_manager = get_node_or_null(wave_manager_path) as WaveManager
	if wave_manager != null:
		wave_manager.countdown_changed.connect(_on_countdown_changed)
	else:
		push_error("[HUD] wave_manager could not be resolved from path: %s" % wave_manager_path)
	call_deferred("_refresh_all")


func _refresh_all() -> void:
	_on_base_health_changed(GameState.base_current_health, GameState.base_max_health)
	_on_enemies_remaining_changed(GameState.enemies_remaining_in_wave)
	_on_credits_changed(GameState.credits)
	_refresh_wave_label()
	_refresh_status_label()
	_refresh_tower_labels()
	_refresh_income_label()
	_refresh_next_wave_label()


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
	_refresh_next_wave_label()


func _on_wave_started(_wave_index: int, _total_waves: int) -> void:
	_refresh_wave_label()
	_refresh_status_label()
	_refresh_next_wave_label()


func _on_wave_completed(_wave_index: int) -> void:
	_refresh_status_label()
	_refresh_next_wave_label()


func _on_countdown_changed(seconds_remaining: float) -> void:
	_countdown_remaining = seconds_remaining
	_refresh_next_wave_label()


func _on_tower_selected_changed(td) -> void:
	_selected_tower_data = td
	_refresh_tower_labels()
	build_hint_label.visible = td != null


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
			status_label.visible = false
		GameState.State.VICTORY:
			status_label.text = "VICTORY! All waves cleared. Press R to restart."
			status_label.visible = true
		GameState.State.DEFEAT:
			status_label.text = "DEFEAT. Your base has fallen. Press R to restart."
			status_label.visible = true


func _refresh_next_wave_label() -> void:
	var s: int = GameState.current_state
	if s != GameState.State.PRE_GAME and s != GameState.State.WAVE_COMPLETE:
		next_wave_label.visible = false
		return
	var next_idx: int = GameState.current_wave_index + 1
	if next_idx >= GameState.total_waves:
		next_wave_label.visible = false
		return
	if wave_manager == null or wave_manager.level_waves == null:
		next_wave_label.visible = false
		return
	var next_wave: WaveData = wave_manager.level_waves.waves[next_idx]
	if next_wave == null:
		next_wave_label.visible = false
		return
	next_wave_label.visible = true
	var summary: String = next_wave.get_summary()
	var prompt: String
	if s == GameState.State.PRE_GAME:
		prompt = "Press N to start"
	else:
		var seconds: int = int(ceil(_countdown_remaining))
		if seconds > 0:
			prompt = "Press N (or wait %ds for +250 credits bonus)" % seconds
		else:
			prompt = "Starting..."
	next_wave_label.text = "Next Wave (%d/%d): %s — %s" % [next_idx + 1, GameState.total_waves, summary, prompt]


func _refresh_tower_labels() -> void:
	if build_manager == null or tower_row == null:
		return
	var entries: Array[PlaceableData] = []
	for td in build_manager.available_towers:
		entries.append(td)
	for bd in build_manager.available_buildings:
		entries.append(bd)
	for i in range(tower_row.get_child_count()):
		var label := tower_row.get_child(i) as Label
		if label == null:
			continue
		if i >= entries.size() or entries[i] == null:
			label.text = ""
			label.visible = false
			continue
		label.visible = true
		var pd: PlaceableData = entries[i]
		var at_cap := false
		var bd := pd as BuildingData
		if bd != null:
			var placed: int = build_manager.count_placed_buildings(bd.placeable_id)
			at_cap = placed >= bd.max_count
			label.text = "[%d] %s — %dc (%d/%d)" % [i + 1, bd.display_name, bd.cost, placed, bd.max_count]
		else:
			label.text = "[%d] %s — %dc" % [i + 1, pd.display_name, pd.cost]
		if pd == _selected_tower_data:
			label.modulate = Color(1.0, 1.0, 0.0)
		elif at_cap or not GameState.can_afford(pd.cost):
			label.modulate = Color(0.55, 0.55, 0.55)
		else:
			label.modulate = Color(1.0, 1.0, 1.0)


func _on_buildings_changed() -> void:
	_refresh_tower_labels()
	_refresh_income_label()


func _refresh_income_label() -> void:
	if income_label == null:
		return
	if build_manager == null or build_manager.available_buildings.is_empty():
		income_label.visible = false
		return
	var bd: BuildingData = build_manager.available_buildings[0]
	if bd == null:
		income_label.visible = false
		return
	income_label.visible = true
	var placed: int = build_manager.count_placed_buildings(bd.placeable_id)
	income_label.text = "Supply: %d/%d (+%d/%ds)" % [placed, bd.max_count, placed * SupplyCenter.DELIVERY_AMOUNT, int(SupplyCenter.CYCLE_TIME)]
