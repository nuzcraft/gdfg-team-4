@tool
class_name TileMapDualEditorPlugin
extends EditorPlugin

static var instance: TileMapDualEditorPlugin = null


# TODO: create a message queue that groups warnings, errors, and messages into categories
# so that we don't get 300 lines of the same warnings pushed to console every time we undo/redo


func _enter_tree() -> void:
	# assign singleton instance
	instance = self
	# register custom nodes
	add_custom_type("TileMapDual", "TileMapLayer", preload("TileMapDual.gd"), preload("TileMapDual.svg"))
	add_custom_type("CursorDual", "Sprite2D", preload("CursorDual.gd"), preload("CursorDual.svg"))
	add_custom_type("TileMapDualLegacy", "TileMapLayer", preload("TileMapDualLegacy.gd"), preload("TileMapDual.svg"))
	# load editor-only functions
	TileMapDual.autotile = autotile
	TileMapDual.popup = popup
	# finish
	print("plugin TileMapDual loaded")


func _exit_tree() -> void:
	# disable editor-only functions
	TileMapDual.popup = TileMapDual._editor_only.bind('popup').unbind(2)
	TileMapDual.autotile = TileMapDual._editor_only.bind('autotile').unbind(3)
	# remove custom nodes
	remove_custom_type("TileMapDualLegacy")
	remove_custom_type("CursorDual")
	remove_custom_type("TileMapDual")
	# unassign singleton instance
	instance = null
	# finish
	print("plugin TileMapDual unloaded")


# HACK: functions that reference EditorPlugin, directly or indirectly, cannot be in the publicly exported scripts
# or else they simply won't work when exported

## Shows a popup with a title bar, a message, and an "Ok" button in the middle of the screen.
func popup(title: String, message: String) -> void:
	var popup := AcceptDialog.new()
	get_editor_interface().get_base_control().add_child(popup)
	popup.name = 'TileMapDualPopup'
	popup.title = title
	popup.dialog_text = message
	popup.popup_centered()
	await popup.confirmed
	popup.queue_free()


## Automatically generate terrains when the atlas is initialized.
func autotile(source_id: int, atlas: TileSetAtlasSource, tile_set: TileSet):
	print_stack()
	var urm := get_undo_redo()
	urm.create_action("Create tiles in non-transparent texture regions", UndoRedo.MergeMode.MERGE_ALL, self, true)
	# NOTE: commit_action() is called immediately after.
	# NOTE: Atlas is guaranteed to have only been auto-generated with no extra peering bit information.
	TerrainPreset.write_default_preset(urm, tile_set, atlas)
	urm.commit_action()