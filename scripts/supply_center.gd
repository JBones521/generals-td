class_name SupplyCenter
extends Node3D

const DELIVERY_AMOUNT: int = 120
const CYCLE_TIME: float = 12.0
const HOVER_HEIGHT: float = 6.0
const FLY_OUT_DISTANCE: float = 10.0

enum Phase { ASCEND, FLY_OUT, FLY_BACK, DESCEND, LOADING }

var _chinook: Node3D
var _phase: Phase = Phase.LOADING
var _phase_time: float = 0.0
var _pad_pos: Vector3
var _hover_pos: Vector3
var _out_pos: Vector3


func _ready() -> void:
	_chinook = get_node_or_null("Chinook") as Node3D
	if _chinook == null:
		push_error("[SupplyCenter] Chinook node missing — deliveries disabled")
		set_process(false)
		return
	_pad_pos = _chinook.position
	_hover_pos = Vector3(_pad_pos.x, HOVER_HEIGHT, _pad_pos.z)
	_out_pos = _hover_pos + _nearest_edge_direction() * FLY_OUT_DISTANCE


func _nearest_edge_direction() -> Vector3:
	var p := global_position
	if abs(p.x) >= abs(p.z):
		return Vector3(1, 0, 0) if p.x >= 0.0 else Vector3(-1, 0, 0)
	return Vector3(0, 0, 1) if p.z >= 0.0 else Vector3(0, 0, -1)


func _phase_duration(phase: Phase) -> float:
	match phase:
		Phase.ASCEND:
			return CYCLE_TIME * (2.0 / 12.0)
		Phase.FLY_OUT:
			return CYCLE_TIME * (3.5 / 12.0)
		Phase.FLY_BACK:
			return CYCLE_TIME * (3.5 / 12.0)
		Phase.DESCEND:
			return CYCLE_TIME * (2.0 / 12.0)
		Phase.LOADING:
			return CYCLE_TIME * (1.0 / 12.0)
	return 1.0


func _process(delta: float) -> void:
	_phase_time += delta
	var duration := _phase_duration(_phase)
	var t: float = clamp(_phase_time / duration, 0.0, 1.0)
	match _phase:
		Phase.ASCEND:
			_chinook.position = _pad_pos.lerp(_hover_pos, t)
		Phase.FLY_OUT:
			_chinook.position = _hover_pos.lerp(_out_pos, t)
			_face_travel(_out_pos - _hover_pos, delta)
		Phase.FLY_BACK:
			_chinook.position = _out_pos.lerp(_hover_pos, t)
			_face_travel(_hover_pos - _out_pos, delta)
		Phase.DESCEND:
			_chinook.position = _hover_pos.lerp(_pad_pos, t)
		Phase.LOADING:
			pass
	if _phase_time < duration:
		return
	_phase_time = 0.0
	match _phase:
		Phase.ASCEND:
			_phase = Phase.FLY_OUT
		Phase.FLY_OUT:
			_phase = Phase.FLY_BACK
		Phase.FLY_BACK:
			_phase = Phase.DESCEND
		Phase.DESCEND:
			GameState.add_credits(DELIVERY_AMOUNT)
			_phase = Phase.LOADING
		Phase.LOADING:
			_phase = Phase.ASCEND


func _face_travel(direction: Vector3, delta: float) -> void:
	if direction.length_squared() < 0.0001:
		return
	_chinook.rotation.y = lerp_angle(_chinook.rotation.y, atan2(direction.x, direction.z), 6.0 * delta)
