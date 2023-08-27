extends Node


var popup_parent_node: CanvasLayer setget set_popup_parent_node
var popup_position: Vector2 = Vector2.ZERO

var popup_messages: Array = [
	"Calculation not possible, no sample data provided!", #0
	"Calculation not possible, main tab incomplete!", #1
	"Calculation not possible, to few calculation tabs provided!", #2
	"Calculation not possible (unknown reason), please check your inputs!", #3
	"Calculation completed!", #4
	"Calculation not possible, missing volume column/sheet!", #5
	"Calculation not possible, missing masses column/sheet!", #6
]

func _ready() -> void:
	popup_position = get_viewport().size/2


func show_popup(text_index: int) -> void:
	var new_popup: AcceptDialog = AcceptDialog.new()
	popup_parent_node.add_child(new_popup)
	if text_index < popup_messages.size():
		new_popup.dialog_text = popup_messages[text_index]
	else:
		new_popup.dialog_text = "Unknown error!"
	new_popup.rect_position = popup_position
	new_popup.popup()


func show_error_popup(text) -> void:
	var new_popup: AcceptDialog = AcceptDialog.new()
	popup_parent_node.add_child(new_popup)
	new_popup.dialog_text = "Error: " + str(text)
	new_popup.rect_position = popup_position
	new_popup.popup()


func set_popup_parent_node(node: CanvasLayer) -> void:
	popup_parent_node = node
