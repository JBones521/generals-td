class_name StrategyCenter
extends Building

const PASSIVE_AMOUNT: int = 30
const PASSIVE_INTERVAL: float = 3.0


func _ready() -> void:
	var timer := Timer.new()
	timer.wait_time = PASSIVE_INTERVAL
	timer.autostart = true
	timer.timeout.connect(_on_passive_tick)
	add_child(timer)


func _on_passive_tick() -> void:
	GameState.add_credits(PASSIVE_AMOUNT)
