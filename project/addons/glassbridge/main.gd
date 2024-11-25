@tool
extends EditorPlugin

# var VMT_IMPORT_PLUGIN: EditorImportPlugin = null

func _enter_tree():
	pass
	# VMT_IMPORT_PLUGIN = preload("res://addons/godotglassbridge/scripts/vmt.gd").new()
	# add_import_plugin(VMT_IMPORT_PLUGIN)


func _exit_tree():
	pass
	# remove_import_plugin(VMT_IMPORT_PLUGIN)
	# VMT_IMPORT_PLUGIN = null
