extends Node

enum State {
	PRE_GAME,
	WAVE_ACTIVE,
	WAVE_COMPLETE,
	VICTORY,
	DEFEAT,
}

const DEBUG_LOGGING: bool = false

const STARTING_CREDITS: int = 1500
const STARTING_BASE_HEALTH: int = 40

signal state_changed(new_state)
signal wave_started(wave_index, total_waves)
signal wave_completed(wave_index)
signal base_health_changed(current, max)
signal enemies_remaining_changed(count)
signal credits_changed(new_amount)

var current_state: State = State.PRE_GAME
var current_wave_index: int = -1
var total_waves: int = 0
var base_max_health: int = STARTING_BASE_HEALTH
var base_current_health: int = STARTING_BASE_HEALTH
var enemies_remaining_in_wave: int = 0
var credits: int = STARTING_CREDITS
var early_start_bonus: int = 0


func start_next_wave() -> void:
	if current_state == State.VICTORY or current_state == State.DEFEAT:
		return
	if current_wave_index + 1 >= total_waves:
		return
	current_wave_index += 1
	_set_state(State.WAVE_ACTIVE)
	wave_started.emit(current_wave_index, total_waves)


func on_enemy_reached_base(damage: int) -> void:
	if current_state == State.DEFEAT:
		return
	base_current_health -= damage
	if base_current_health < 0:
		base_current_health = 0
	base_health_changed.emit(base_current_health, base_max_health)
	if base_current_health <= 0:
		_set_state(State.DEFEAT)


func on_enemy_killed() -> void:
	if enemies_remaining_in_wave <= 0:
		return
	enemies_remaining_in_wave -= 1
	enemies_remaining_changed.emit(enemies_remaining_in_wave)
	if enemies_remaining_in_wave == 0 and current_state == State.WAVE_ACTIVE:
		if current_wave_index + 1 >= total_waves:
			_set_state(State.VICTORY)
		else:
			_set_state(State.WAVE_COMPLETE)
		wave_completed.emit(current_wave_index)


func add_credits(amount: int) -> void:
	if amount <= 0:
		return
	credits += amount
	credits_changed.emit(credits)


func spend_credits(amount: int) -> bool:
	if amount < 0 or credits < amount:
		return false
	credits -= amount
	credits_changed.emit(credits)
	return true


func can_afford(amount: int) -> bool:
	return credits >= amount


func reset_game() -> void:
	current_state = State.PRE_GAME
	current_wave_index = -1
	base_max_health = STARTING_BASE_HEALTH
	base_current_health = STARTING_BASE_HEALTH
	enemies_remaining_in_wave = 0
	credits = STARTING_CREDITS
	early_start_bonus = 0
	state_changed.emit(current_state)
	base_health_changed.emit(base_current_health, base_max_health)
	enemies_remaining_changed.emit(0)
	credits_changed.emit(credits)


func _set_state(new_state: State) -> void:
	if current_state == new_state:
		return
	current_state = new_state
	state_changed.emit(new_state)
