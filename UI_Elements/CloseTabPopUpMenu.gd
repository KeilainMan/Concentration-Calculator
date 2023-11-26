extends PopupMenu





signal close_this_tab()


func _ready() -> void:
	connect("close_this_tab", get_parent(), "_on_close_this_tab")

	rect_position = get_global_mouse_position()
	popup()



func _on_PopupMenu_id_pressed(id: int) -> void:
	if id == 0:
		emit_signal("close_this_tab")
