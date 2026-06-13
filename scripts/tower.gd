class_name Tower
extends Node3D

enum TargetingStrategy {
	FIRST_IN_RANGE,
	MOST_PROGRESSED,
}

@export var tower_data: TowerData
@export var tower_name: String = "Basic Tower"
@export var attack_range: float = 10.0
@export var fire_rate: float = 1.0
@export var damage: float = 10.0
@export var show_range_indicator: bool = true
@export var targeting_strategy: TargetingStrategy = TargetingStrategy.MOST_PROGRESSED

var enemies_in_range: Array[Node3D] = []

var _time_since_last_shot: float = 0.0
var _current_target: Node3D = null
var _turret: Node3D = null
var _muzzle: Node3D = null


func _ready() -> void:
	_turret = get_node_or_null("Turret") as Node3D
	_muzzle = get_node_or_null("Turret/Muzzle") as Node3D
	if tower_data != null:
		attack_range = tower_data.attack_range
		fire_rate = tower_data.fire_rate
		damage = tower_data.damage
		if tower_data.display_name != "":
			tower_name = tower_data.display_name
	var torus := _apply_range_to_indicator()
	var sphere := _apply_range_to_detection_area()
	if torus == null:
		push_error("[Tower] RangeIndicator/TorusMesh missing — visual range not synced")
	if sphere == null:
		push_error("[Tower] DetectionArea/SphereShape3D missing — detection radius not synced")
	if GameState.DEBUG_LOGGING:
		var torus_outer: float = torus.outer_radius if torus != null else -1.0
		var sphere_radius: float = sphere.radius if sphere != null else -1.0
		print("[Tower] ", tower_name, " attack_range=", attack_range, " torus_outer=", torus_outer, " sphere_radius=", sphere_radius)


func _apply_range_to_indicator() -> TorusMesh:
	var indicator := get_node_or_null("RangeIndicator") as MeshInstance3D
	if indicator == null:
		return null
	indicator.visible = show_range_indicator
	var torus := indicator.mesh as TorusMesh
	if torus == null:
		return null
	torus.outer_radius = attack_range
	torus.inner_radius = max(attack_range - 0.1, 0.0)
	return torus


func _apply_range_to_detection_area() -> SphereShape3D:
	var area := get_node_or_null("DetectionArea") as Area3D
	if area == null:
		return null
	if not area.body_entered.is_connected(_on_body_entered):
		area.body_entered.connect(_on_body_entered)
	if not area.body_exited.is_connected(_on_body_exited):
		area.body_exited.connect(_on_body_exited)
	var collision_shape := area.get_node_or_null("CollisionShape3D") as CollisionShape3D
	if collision_shape == null:
		return null
	var sphere := collision_shape.shape as SphereShape3D
	if sphere == null:
		return null
	sphere.radius = attack_range
	return sphere


func _process(delta: float) -> void:
	_time_since_last_shot += delta
	_prune_invalid_enemies()
	_current_target = _select_target()
	if _turret != null and _current_target != null and is_instance_valid(_current_target):
		var to_t := _current_target.global_position - _turret.global_position
		_turret.rotation.y = lerp_angle(_turret.rotation.y, atan2(to_t.x, to_t.z), 8.0 * delta)
	if _time_since_last_shot < 1.0 / fire_rate:
		return
	if _current_target == null:
		return
	_fire_at(_current_target)
	_time_since_last_shot = 0.0


func _prune_invalid_enemies() -> void:
	var valid: Array[Node3D] = []
	for e in enemies_in_range:
		if is_instance_valid(e) and not e.is_queued_for_deletion():
			valid.append(e)
	enemies_in_range = valid


func _select_target() -> Node3D:
	match targeting_strategy:
		TargetingStrategy.MOST_PROGRESSED:
			var best: Node3D = null
			var best_progress: float = -INF
			for e in enemies_in_range:
				if not is_instance_valid(e) or e.is_queued_for_deletion():
					continue
				if not e.has_method("get_path_progress"):
					continue
				var progress: float = e.get_path_progress()
				if progress > best_progress:
					best_progress = progress
					best = e
			return best
		_:
			for e in enemies_in_range:
				if is_instance_valid(e) and not e.is_queued_for_deletion():
					return e
			return null


func _fire_at(target: Node3D) -> void:
	if not is_instance_valid(target) or target.is_queued_for_deletion():
		return
	var dmg: float = damage
	var enemy_target := target as Enemy
	if tower_data != null and enemy_target != null:
		match enemy_target.enemy_type:
			"infantry":
				dmg = damage * tower_data.damage_vs_infantry_mult
			"vehicle":
				dmg = damage * tower_data.damage_vs_vehicle_mult
	var target_pos: Vector3 = target.global_position
	if GameState.DEBUG_LOGGING:
		print("[Tower] ", name, " (", tower_name, ") firing at ", target.name, " at ", target_pos, " damage=", dmg)
	if target.has_method("take_damage"):
		target.take_damage(dmg)
	_show_tracer(target_pos)


func _show_tracer(target_pos: Vector3) -> void:
	var gun_pos: Vector3
	if _muzzle != null:
		gun_pos = _muzzle.global_position
	else:
		gun_pos = global_position + Vector3(0, 2.5, 0)
	var tracer := MeshInstance3D.new()
	tracer.top_level = true
	var im := ImmediateMesh.new()
	var mat := StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = Color(1.0, 0.5, 0.0)
	im.surface_begin(Mesh.PRIMITIVE_LINE_STRIP, mat)
	im.surface_add_vertex(gun_pos)
	im.surface_add_vertex(target_pos)
	im.surface_end()
	tracer.mesh = im
	var parent: Node = get_tree().current_scene
	if parent == null:
		parent = get_parent()
	parent.add_child(tracer)
	get_tree().create_timer(0.1).timeout.connect(tracer.queue_free)


func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("enemies"):
		return
	if body is Node3D:
		enemies_in_range.append(body)


func _on_body_exited(body: Node) -> void:
	if body is Node3D:
		enemies_in_range.erase(body)
