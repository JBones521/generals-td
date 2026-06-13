@tool
class_name PathVisualizer
extends Node3D

const _OWNED_META: String = "path_visualizer_owned"

@export var paths: Array[PathData] = []:
	set(value):
		_disconnect_path_signals()
		paths = value
		_connect_path_signals()
		_request_rebuild()

@export var line_height: float = 0.2:
	set(value):
		line_height = value
		_request_rebuild()

@export var show_roads: bool = true:
	set(value):
		show_roads = value
		_request_rebuild()

@export var show_debug_lines: bool = false:
	set(value):
		show_debug_lines = value
		_request_rebuild()


func _ready() -> void:
	_connect_path_signals()
	_rebuild()


func _exit_tree() -> void:
	_disconnect_path_signals()


func _request_rebuild() -> void:
	if not is_inside_tree():
		return
	call_deferred("_rebuild")


func _rebuild() -> void:
	if not is_inside_tree():
		return
	_clear_owned_children()
	for path in paths:
		if path == null or path.waypoints.size() < 2:
			continue
		if show_roads:
			_build_road(path)
		if show_debug_lines:
			_build_line(path)


func _clear_owned_children() -> void:
	for child in get_children():
		if child.has_meta(_OWNED_META):
			remove_child(child)
			child.queue_free()


func _connect_path_signals() -> void:
	for path in paths:
		if path != null and not path.changed.is_connected(_request_rebuild):
			path.changed.connect(_request_rebuild)


func _disconnect_path_signals() -> void:
	for path in paths:
		if path != null and path.changed.is_connected(_request_rebuild):
			path.changed.disconnect(_request_rebuild)


func _build_road(path: PathData) -> void:
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.45, 0.38, 0.28)
	for i in range(1, path.waypoints.size()):
		var a := path.waypoints[i - 1]
		var b := path.waypoints[i]
		var flat := Vector3(b.x - a.x, 0.0, b.z - a.z)
		var seg_len := flat.length()
		if seg_len < 0.001:
			continue
		var segment := MeshInstance3D.new()
		segment.name = "Road_%s_%d" % [path.path_name if path.path_name != "" else "unnamed", i]
		segment.set_meta(_OWNED_META, true)
		var box := BoxMesh.new()
		box.size = Vector3(2.5, 0.05, seg_len)
		box.material = material
		segment.mesh = box
		add_child(segment)
		segment.position = Vector3((a.x + b.x) * 0.5, 0.03, (a.z + b.z) * 0.5)
		segment.rotation.y = atan2(flat.x, flat.z)


func _build_line(path: PathData) -> void:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = "PathLine_" + (path.path_name if path.path_name != "" else "unnamed")
	mesh_instance.set_meta(_OWNED_META, true)

	var immediate_mesh := ImmediateMesh.new()
	var material := StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = path.debug_color
	material.vertex_color_use_as_albedo = true

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINE_STRIP, material)
	for waypoint in path.waypoints:
		var p := waypoint
		p.y += line_height
		immediate_mesh.surface_set_color(path.debug_color)
		immediate_mesh.surface_add_vertex(p)
	immediate_mesh.surface_end()

	mesh_instance.mesh = immediate_mesh
	add_child(mesh_instance)
