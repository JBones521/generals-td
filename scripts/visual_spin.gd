class_name VisualSpin
extends Node3D

@export var spin_speed_deg: float = 180.0
@export var bob_amplitude: float = 0.0
@export var bob_speed: float = 2.0

var _initial_y: float = 0.0
var _bob_time: float = 0.0


func _ready() -> void:
	_initial_y = position.y


func _process(delta: float) -> void:
	rotate_y(deg_to_rad(spin_speed_deg) * delta)
	if bob_amplitude > 0.0:
		_bob_time += delta
		position.y = _initial_y + sin(_bob_time * bob_speed) * bob_amplitude
