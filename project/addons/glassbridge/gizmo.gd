extends EditorNode3DGizmoPlugin

var undo_redo = UndoRedo.new()

func _has_gizmo(node):
	return node is GlassVolume3D

func _get_gizmo_name():
	return "GlassVolumeGizmo"

func _init():
	create_material("focus", Color("#ff7f00"))
	create_material("bounds", Color("#cc66cc"))
	create_handle_material("handles")

func _redraw(gizmo: EditorNode3DGizmo):
	gizmo.clear()

	var display: GlassVolume3D = gizmo.get_node_3d()

	var aspect: float = display.get_aspect()
	var size: float = display.size
	var near: float = size * display.near_clip
	var far: float = size * display.far_clip

	var half_extents: Vector2 = Vector2(0.5 * size, 0.5 * size / aspect)

	# Focus plane
	var lines: PackedVector3Array = PackedVector3Array()
	lines.push_back(Vector3(-half_extents.x, -half_extents.y, 0.0))
	lines.push_back(Vector3( half_extents.x, -half_extents.y, 0.0))
	lines.push_back(Vector3( half_extents.x, -half_extents.y, 0.0))
	lines.push_back(Vector3( half_extents.x,  half_extents.y, 0.0))
	lines.push_back(Vector3( half_extents.x,  half_extents.y, 0.0))
	lines.push_back(Vector3(-half_extents.x,  half_extents.y, 0.0))
	lines.push_back(Vector3(-half_extents.x,  half_extents.y, 0.0))
	lines.push_back(Vector3(-half_extents.x, -half_extents.y, 0.0))

	# Top indicator notch.
	lines.push_back(Vector3(-0.2*half_extents.x, half_extents.y, 0.0))
	lines.push_back(Vector3(0.0, 1.2*half_extents.y, 0.0))
	lines.push_back(Vector3(0.0, 1.2*half_extents.y, 0.0))
	lines.push_back(Vector3(0.2*half_extents.x, half_extents.y, 0.0))

	gizmo.add_lines(lines, get_material("focus", gizmo), false)

	# Near plane.
	lines = PackedVector3Array()
	lines.push_back(Vector3(-half_extents.x, -half_extents.y, near))
	lines.push_back(Vector3( half_extents.x, -half_extents.y, near))
	lines.push_back(Vector3( half_extents.x, -half_extents.y, near))
	lines.push_back(Vector3( half_extents.x,  half_extents.y, near))
	lines.push_back(Vector3( half_extents.x,  half_extents.y, near))
	lines.push_back(Vector3(-half_extents.x,  half_extents.y, near))
	lines.push_back(Vector3(-half_extents.x,  half_extents.y, near))
	lines.push_back(Vector3(-half_extents.x, -half_extents.y, near))

	# Far plane.
	lines.push_back(Vector3(-half_extents.x, -half_extents.y, -far))
	lines.push_back(Vector3( half_extents.x, -half_extents.y, -far))
	lines.push_back(Vector3( half_extents.x, -half_extents.y, -far))
	lines.push_back(Vector3( half_extents.x,  half_extents.y, -far))
	lines.push_back(Vector3( half_extents.x,  half_extents.y, -far))
	lines.push_back(Vector3(-half_extents.x,  half_extents.y, -far))
	lines.push_back(Vector3(-half_extents.x,  half_extents.y, -far))
	lines.push_back(Vector3(-half_extents.x, -half_extents.y, -far))

	# Cross on the far plane.
	lines.push_back(Vector3(-half_extents.x, -half_extents.y, -far))
	lines.push_back(Vector3( half_extents.x,  half_extents.y, -far))
	lines.push_back(Vector3( half_extents.x, -half_extents.y, -far))
	lines.push_back(Vector3(-half_extents.x,  half_extents.y, -far))

	# Connecting edges.
	lines.push_back(Vector3(-half_extents.x, -half_extents.y, near))
	lines.push_back(Vector3(-half_extents.x, -half_extents.y, -far))
	lines.push_back(Vector3( half_extents.x, -half_extents.y, near))
	lines.push_back(Vector3( half_extents.x, -half_extents.y, -far))
	lines.push_back(Vector3( half_extents.x,  half_extents.y, near))
	lines.push_back(Vector3( half_extents.x,  half_extents.y, -far))
	lines.push_back(Vector3(-half_extents.x,  half_extents.y, near))
	lines.push_back(Vector3(-half_extents.x,  half_extents.y, -far))

	gizmo.add_lines(lines, get_material("bounds", gizmo), false)

	# Handles
	var handles: PackedVector3Array = PackedVector3Array()
	handles.push_back(Vector3(0.0, 0.0, near))
	handles.push_back(Vector3(0.0, 0.0, -far))
	handles.push_back(Vector3(0.5*size, 0.5*size/aspect, 0.0))
	gizmo.add_handles(handles, get_material("handles"), [0, 1, 2])

func _get_handle_name(gizmo: EditorNode3DGizmo, handle_id: int, secondary: bool) -> String:
	match handle_id:
		0:
			return "near_clip"
		1:
			return "far_clip"
		2:
			return "size"
		_:
			return ""

func _get_handle_value(gizmo: EditorNode3DGizmo, handle_id: int, secondary: bool) -> Variant:
	var display: GlassVolume3D = gizmo.get_node_3d()
	match handle_id:
		0:
			return display.near_clip
		1:
			return display.far_clip
		2:
			return display.size
		_:
			return 0.0

func _set_handle(gizmo: EditorNode3DGizmo, handle_id: int, secondary: bool, camera: Camera3D, screen_pos: Vector2) -> void:
	var display: GlassVolume3D = gizmo.get_node_3d()

	var gt: Transform3D = display.get_global_transform()
	var gi: Transform3D = gt.affine_inverse()

	var ray_from: Vector3 = camera.project_ray_origin(screen_pos)
	var ray_dir: Vector3 = camera.project_ray_normal(screen_pos)

	var sg: Array = [ gi * ray_from, gi * (ray_from + ray_dir * 4096)]

	if (handle_id < 2):
		var r: PackedVector3Array = Geometry3D.get_closest_points_between_segments(Vector3(0, 0, -4096), Vector3(0, 0, 4096), sg[0], sg[1])
		var d: float = r[0].z

		match handle_id:
			0:
				display.near_clip = d / display.size
			1:
				display.far_clip = -d / display.size
	elif (handle_id == 2):
		var r: PackedVector3Array = Geometry3D.get_closest_points_between_segments(Vector3(0, 0, 0), Vector3(4096, 4096 / display.get_aspect(), 0), sg[0], sg[1])
		var d: float = r[0].x

		display.size = 2.0 * d

func _commit_handle(gizmo: EditorNode3DGizmo, handle_id: int, secondary: bool, restore: Variant, cancel: bool) -> void:
	var display: GlassVolume3D = gizmo.get_node_3d()

	match handle_id:
		0:
			if cancel:
				display.near_plane = restore
				return
			undo_redo.create_action("Change HoloPlayVolume Near Clip")
			undo_redo.add_do_property(display, "near_clip", display.near_clip)
			undo_redo.add_undo_property(display, "near_clip", restore)
			undo_redo.commit_action()
		1:
			if cancel:
				display.far_plane = restore
				return
			undo_redo.create_action("Change HoloPlayVolume Far Clip")
			undo_redo.add_do_property(display, "far_clip", display.far_clip)
			undo_redo.add_undo_property(display, "far_clip", restore)
			undo_redo.commit_action()
		2:
			if cancel:
				display.size = restore
				return
			undo_redo.create_action("Change HoloPlayVolume Size")
			undo_redo.add_do_property(display, "size", display.size)
			undo_redo.add_undo_property(display, "size", restore)
			undo_redo.commit_action()