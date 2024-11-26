@tool
extends EditorPlugin

const GlassViewGizmoPlugin = preload("res://addons/glassbridge/gizmo.gd");
var glassViewGizmoPlugin = GlassViewGizmoPlugin.new();

func _enter_tree():
	add_node_3d_gizmo_plugin(glassViewGizmoPlugin);

func _exit_tree():
	remove_node_3d_gizmo_plugin(glassViewGizmoPlugin);
