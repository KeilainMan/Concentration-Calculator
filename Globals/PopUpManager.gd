extends Node


var popup_parent_node: CanvasLayer setget set_popup_parent_node
var popup_position: Vector2 = Vector2.ZERO

var popup_messages: Array = [
	"Calculation not possible, please check you inputs!",
]

func _ready() -> void:
	popup_position = get_viewport().size/2


func show_popup(text_index: int) -> void:
	var new_popup: AcceptDialog = AcceptDialog.new()
	popup_parent_node.add_child(new_popup)
	new_popup.dialog_text = popup_messages[text_index]
	new_popup.rect_position = popup_position
	new_popup.popup()


func set_popup_parent_node(node: CanvasLayer) -> void:
	popup_parent_node = node
