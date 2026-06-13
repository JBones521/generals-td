class_name BuildManager
extends Node3D

signal tower_selected_changed(placeable_data)
signal buildings_changed
signal tower_selection_changed(tower)

@export var available_towers: Array[TowerData] = []
@export var available_buildings: Array[BuildingData] = []
@export var paths: Array[PathData] = []
@export var ground_layer_mask: int = 2
@export var min_distance_to_path: float = 2.0
@export var min_tower_spacing: float = 2.0

var selected_placeable: PlaceableData = null
var preview_instance: Node3D = null
var placed_towers: Array[Tower] = []
var placed_buildings: Array[Node3D] = []
var selected_tower: Tower = null

var _preview_indicator_material: StandardMaterial3D


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_1:
				if available_towers.size() >= 1:
					_select_placeable(available_towers[0])
			KEY_2:
				if available_towers.size() >= 2:
					_select_placeable(available_towers[1])
			KEY_3:
				if available_towers.size() >= 3:
					_select_placeable(available_towers[2])
			KEY_4:
				if available_buildings.size() >= 1:
					_select_placeable(available_buildings[0])
			KEY_5:
				if available_buildings.size() >= 2:
					_select_placeable(available_buildings[1])
			KEY_U:
				_try_upgrade_selected()
			KEY_S:
				_try_sell_selected()
			KEY_ESCAPE:
				if preview_instance != null:
					_cancel_placement()
				elif selected_tower != null:
					_deselect_tower()
	elif event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if preview_instance != null:
				_try_place()
			else:
				_handle_select_click()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if preview_instance != null:
				_cancel_placement()
			elif selected_tower != null:
				_deselect_tower()


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


func count_placed_buildings(id: String) -> int:
	var count := 0
	for b in placed_buildings:
		if is_instance_valid(b) and b.get_meta("placeable_id", "") == id:
			count += 1
	return count


func has_building(id: String) -> bool:
	for b in placed_buildings:
		if not is_instance_valid(b):
			continue
		var building := b as Building
		if building != null and building.building_data != null and building.building_data.placeable_id == id:
			return true
		if b.get_meta("placeable_id", "") == id:
			return true
	return false


func is_upgrade_allowed(tower: Tower) -> bool:
	if tower == null or tower.tier >= 3:
		return false
	if tower.tier == 1:
		return GameState.current_wave_index >= 4
	return GameState.current_wave_index >= 9 and has_building("usa_strategy_center")


func _handle_select_click() -> void:
	var hit = _raycast_to_ground()
	if hit == null:
		_deselect_tower()
		return
	var nearest: Tower = null
	var nearest_d: float = 1.8
	for t in placed_towers:
		if not is_instance_valid(t) or t.is_queued_for_deletion():
			continue
		var d: float = t.global_position.distance_to(hit)
		if d <= nearest_d:
			nearest_d = d
			nearest = t
	if nearest == null:
		_deselect_tower()
		return
	_select_tower_instance(nearest)


func _select_tower_instance(tower: Tower) -> void:
	_cancel_placement()
	if selected_tower == tower:
		return
	_deselect_tower()
	selected_tower = tower
	tower.set_range_indicator_visible(true)
	tower_selection_changed.emit(tower)


func _deselect_tower() -> void:
	if selected_tower == null:
		return
	if is_instance_valid(selected_tower):
		selected_tower.set_range_indicator_visible(selected_tower.show_range_indicator)
	selected_tower = null
	tower_selection_changed.emit(null)


func _try_upgrade_selected() -> void:
	if selected_tower == null or not is_instance_valid(selected_tower):
		return
	if selected_tower.tier >= 3 or not is_upgrade_allowed(selected_tower):
		return
	var cost: int = selected_tower.get_upgrade_cost()
	if cost < 0 or not GameState.spend_credits(cost):
		return
	selected_tower.upgrade()
	tower_selection_changed.emit(selected_tower)
	if GameState.DEBUG_LOGGING:
		print("[BuildManager] upgraded %s to tier %d (cost=%d)" % [selected_tower.tower_name, selected_tower.tier, cost])


func _try_sell_selected() -> void:
	if selected_tower == null or not is_instance_valid(selected_tower):
		return
	var refund: int = int(round(selected_tower.total_invested * 0.75))
	GameState.add_credits(refund)
	placed_towers.erase(selected_tower)
	var sold := selected_tower
	selected_tower = null
	sold.queue_free()
	tower_selection_changed.emit(null)
	if GameState.DEBUG_LOGGING:
		print("[BuildManager] sold %s (refund=%d)" % [sold.tower_name, refund])


func _select_placeable(pd: PlaceableData) -> void:
	if pd == null:
		return
	_deselect_tower()
	_cancel_placement()
	selected_placeable = pd
	_create_preview(pd)
	tower_selected_changed.emit(pd)
	if GameState.DEBUG_LOGGING:
		print("[BuildManager] selected %s (cost=%d)" % [pd.placeable_id, pd.cost])


func _cancel_placement() -> void:
	if preview_instance != null:
		preview_instance.queue_free()
		preview_instance = null
	_preview_indicator_material = null
	var was_selected := selected_placeable != null
	selected_placeable = null
	if was_selected:
		tower_selected_changed.emit(null)


func _create_preview(pd: PlaceableData) -> void:
	if pd == null or pd.scene == null:
		push_error("[BuildManager] cannot create preview — scene missing for %s" % (pd.placeable_id if pd != null else "<null>"))
		return
	var preview := pd.scene.instantiate() as Node3D
	if preview == null:
		push_error("[BuildManager] could not instantiate scene for %s" % pd.placeable_id)
		return
	var tower_preview := preview as Tower
	if tower_preview != null:
		tower_preview.tower_data = pd as TowerData
		tower_preview.show_range_indicator = true
	var hit = _raycast_to_ground()
	if hit != null:
		preview.position = hit
	add_child(preview)
	preview.process_mode = Node.PROCESS_MODE_DISABLED
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
	if hit != null:
		_update_preview_color(_is_valid_placement(hit))


func _update_preview_color(valid: bool) -> void:
	if _preview_indicator_material == null:
		return
	_preview_indicator_material.albedo_color = Color(0, 1, 0, 0.4) if valid else Color(1, 0, 0, 0.4)


func _is_valid_placement(pos: Vector3) -> bool:
	if selected_placeable == null:
		return false
	if not GameState.can_afford(selected_placeable.cost):
		return false
	if _min_distance_to_paths(pos) < min_distance_to_path:
		return false
	for t in placed_towers:
		if not is_instance_valid(t):
			continue
		if t.global_position.distance_to(pos) < min_tower_spacing:
			return false
	for b in placed_buildings:
		if not is_instance_valid(b):
			continue
		if b.global_position.distance_to(pos) < min_tower_spacing:
			return false
	var bd := selected_placeable as BuildingData
	if bd != null and count_placed_buildings(bd.placeable_id) >= bd.max_count:
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


func _try_place() -> void:
	if preview_instance == null or selected_placeable == null:
		return
	var pos: Vector3 = preview_instance.global_position
	if not _is_valid_placement(pos):
		if GameState.DEBUG_LOGGING:
			print("[BuildManager] placement at %s rejected" % pos)
		return
	var pd := selected_placeable
	var cost: int = pd.cost
	if not GameState.spend_credits(cost):
		if GameState.DEBUG_LOGGING:
			print("[BuildManager] could not spend %d credits" % cost)
		return
	_cancel_placement()
	var instance := pd.scene.instantiate() as Node3D
	if instance == null:
		push_error("[BuildManager] failed to instantiate placed scene for %s" % pd.placeable_id)
		return
	var tower := instance as Tower
	if tower != null:
		tower.tower_data = pd as TowerData
		tower.total_invested = cost
	var building := instance as Building
	if building != null:
		building.building_data = pd as BuildingData
	instance.position = pos
	instance.set_meta("placeable_id", pd.placeable_id)
	add_child(instance)
	if tower != null:
		placed_towers.append(tower)
	else:
		placed_buildings.append(instance)
		buildings_changed.emit()
	if GameState.DEBUG_LOGGING:
		print("[BuildManager] placed %s at %s (cost=%d, credits remaining=%d)" % [pd.placeable_id, pos, cost, GameState.credits])
