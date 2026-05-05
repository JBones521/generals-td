class_name BuildManager
extends Node3D

signal tower_selected_changed(tower_data)

@export var available_towers: Array[TowerData] = []
@export var paths: Array[PathData] = []
@export var ground_layer_mask: int = 1
@export var min_distance_to_path: float = 2.0
@export var min_tower_spacing: float = 2.0

var selected_tower_data: TowerData = null
var preview_instance: Tower = null
var placed_towers: Array[Tower] = []

var _preview_indicator_material: StandardMaterial3D


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_1:
				if available_towers.size() >= 1:
					_select_tower(available_towers[0])
			KEY_2:
				if available_towers.size() >= 2:
					_select_tower(available_towers[1])
			KEY_3:
				if available_towers.size() >= 3:
					_select_tower(available_towers[2])
			KEY_ESCAPE:
				if preview_instance != null:
					_cancel_placement()
	elif event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and preview_instance != null:
			_try_place_tower()
		elif event.button_index == MOUSE_BUTTON_RIGHT and preview_instance != null:
			_cancel_placement()


func _process(_delta: float) -> void:
	if preview_instance == null:
		return
	var hit = _raycast_to_ground()
	if hit == null:
		return
	preview_instance.global_position = hit
	_update_preview_color(_is_valid_placement(hit))


func _raycast_to_ground() -> Variant:
	var camera := get_viewport().get_camera_3d()
	if camera == null:
		return null
	var mouse_pos := get_viewport().get_mouse_position()
	var ray_origin := camera.project_ray_origin(mouse_pos)
	var ray_normal := camera.project_ray_normal(mouse_pos)
	var ray_end := ray_origin + ray_normal * 1000.0
	var space_state := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(ray_origin, ray_end, ground_layer_mask)
	var result := space_state.intersect_ray(query)
	if result.is_empty():
		return null
	return result.position


func _select_tower(td: TowerData) -> void:
	if td == null:
		return
	_cancel_placement()
	selected_tower_data = td
	_create_preview(td)
	tower_selected_changed.emit(td)
	print("[BuildManager] selected %s (cost=%d)" % [td.tower_id, td.cost])


func _cancel_placement() -> void:
	if preview_instance != null:
		preview_instance.queue_free()
		preview_instance = null
	_preview_indicator_material = null
	var was_selected := selected_tower_data != null
	selected_tower_data = null
	if was_selected:
		tower_selected_changed.emit(null)


func _create_preview(td: TowerData) -> void:
	if td == null or td.tower_scene == null:
		push_error("[BuildManager] cannot create preview — tower_scene missing for %s" % td.tower_id if td != null else "<null>")
		return
	var preview := td.tower_scene.instantiate() as Tower
	if preview == null:
		push_error("[BuildManager] could not instantiate tower scene for %s" % td.tower_id)
		return
	preview.tower_data = td
	add_child(preview)
	preview.set_process(false)
	preview.set_physics_process(false)
	var area := preview.get_node_or_null("DetectionArea") as Area3D
	if area != null:
		area.monitoring = false
	var indicator := preview.get_node_or_null("RangeIndicator") as MeshInstance3D
	if indicator != null:
		_preview_indicator_material = StandardMaterial3D.new()
		_preview_indicator_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		_preview_indicator_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		_preview_indicator_material.albedo_color = Color(0, 1, 0, 0.4)
		indicator.set_surface_override_material(0, _preview_indicator_material)
	preview_instance = preview
	var hit = _raycast_to_ground()
	if hit != null:
		preview.global_position = hit
		_update_preview_color(_is_valid_placement(hit))


func _update_preview_color(valid: bool) -> void:
	if _preview_indicator_material == null:
		return
	_preview_indicator_material.albedo_color = Color(0, 1, 0, 0.4) if valid else Color(1, 0, 0, 0.4)


func _is_valid_placement(pos: Vector3) -> bool:
	if selected_tower_data == null:
		return false
	if not GameState.can_afford(selected_tower_data.cost):
		return false
	if _min_distance_to_paths(pos) < min_distance_to_path:
		return false
	for t in placed_towers:
		if not is_instance_valid(t):
			continue
		if t.global_position.distance_to(pos) < min_tower_spacing:
			return false
	return true


func _min_distance_to_paths(pos: Vector3) -> float:
	var min_d: float = INF
	var p2 := Vector2(pos.x, pos.z)
	for path in paths:
		if path == null:
			continue
		var pts: PackedVector3Array = path.waypoints
		if pts.size() < 2:
			continue
		for i in range(1, pts.size()):
			var a := Vector2(pts[i - 1].x, pts[i - 1].z)
			var b := Vector2(pts[i].x, pts[i].z)
			var d := _point_to_segment_distance(p2, a, b)
			if d < min_d:
				min_d = d
	return min_d


func _point_to_segment_distance(p: Vector2, a: Vector2, b: Vector2) -> float:
	var ab := b - a
	var ap := p - a
	var ab_len_sq := ab.length_squared()
	if ab_len_sq <= 0.0001:
		return ap.length()
	var t: float = clamp(ap.dot(ab) / ab_len_sq, 0.0, 1.0)
	var closest := a + ab * t
	return p.distance_to(closest)


func _try_place_tower() -> void:
	if preview_instance == null or selected_tower_data == null:
		return
	var pos: Vector3 = preview_instance.global_position
	if not _is_valid_placement(pos):
		print("[BuildManager] placement at %s rejected" % pos)
		return
	var td := selected_tower_data
	var cost: int = td.cost
	if not GameState.spend_credits(cost):
		print("[BuildManager] could not spend %d credits" % cost)
		return
	_cancel_placement()
	var tower := td.tower_scene.instantiate() as Tower
	if tower == null:
		push_error("[BuildManager] failed to instantiate placed tower for %s" % td.tower_id)
		return
	tower.tower_data = td
	add_child(tower)
	tower.global_position = pos
	placed_towers.append(tower)
	print("[BuildManager] placed %s at %s (cost=%d, credits remaining=%d)" % [td.tower_id, pos, cost, GameState.credits])
