@tool
class_name PathVisualizer
extends Node3D

@export var paths: Array[PathData] = []:
	set(value):
		paths = value
		if is_inside_tree():
			_rebuild()

@export var line_height: float = 0.2:
	set(value):
		line_height = value
		if is_inside_tree():
			_rebuild()


func _ready() -> void:
	_rebuild()


func _rebuild() -> void:
	for child in get_children():
		if child.has_meta("path_visualizer_owned"):
			child.queue_free()

	for path in paths:
		if path == null or path.waypoints.size() < 2:
			continue
		_build_line(path)


func _build_line(path: PathData) -> void:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = "PathLine_" + (path.path_name if path.path_name != "" else "unnamed")
	mesh_instance.set_meta("path_visualizer_owned", true)

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
	if Engine.is_editor_hint() and get_tree() != null and get_tree().edited_scene_root != null:
		mesh_instance.owner = get_tree().edited_scene_root
