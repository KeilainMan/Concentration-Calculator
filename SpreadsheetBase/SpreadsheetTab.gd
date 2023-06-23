extends Tabs
class_name SpeadsheetTab

onready var row_container = $ScrollContainer/RowContainer

var data: Array = [] setget set_data, get_data
var all_labels: Array = []
var all_row_number_labels: Array = []
var all_labels_in_columns: Array = []

var label_min_size: Vector2 = Vector2(100,20)


func display_data() -> void:
	for row_index in data.size():
		insert_row_to_spreadsheet(row_index, data[row_index])
	fancy_layout()


func insert_row_to_spreadsheet(row_number: int, row_data: Array) -> void:
	var row_parent: HBoxContainer = instance_new_row_parent()
	var row_number_label = instance_label_for_entry(row_parent, -1)
	display_value_on_label(row_number_label, row_number)
	
	for column_index in row_data.size():
		all_labels_in_columns.append([])
		var current_label: Label = instance_label_for_entry(row_parent, column_index)
		display_value_on_label(current_label, row_data[column_index])


func display_value_on_label(current_label, element) -> void:
	current_label.text = str(element)


func instance_new_row_parent() -> HBoxContainer:
	var new_row_parent: HBoxContainer = HBoxContainer.new()
	row_container.add_child(new_row_parent)
	
	return(new_row_parent)


func instance_label_for_entry(parent: HBoxContainer, column_index: int) -> Label:
	var new_label = Label.new()
	parent.add_child(new_label)
	
	all_labels.append(new_label)
	if column_index == -1:
		all_row_number_labels.append(new_label)
	else:
		all_labels_in_columns[column_index].append(new_label)
	
	return new_label


func configure_row_number_labels_layout() -> void:
	for label in all_row_number_labels:
		label.rect_min_size = Vector2(20,20)
		label.align = 0


func configure_data_labels_layout() -> void:
	for label in all_labels:
		label.rect_min_size = label_min_size
		label.align = 2
		label.valign = 1
		label.size_flags_horizontal = 2
		label.size_flags_horizontal = 1
		label.clip_text = true


func fancy_layout() -> void:
	configure_data_labels_layout()
	configure_row_number_labels_layout()
	set_first_column_right()


func set_first_column_right() -> void:
	for entry_label in all_labels_in_columns[0]:
		entry_label.align = 0


func set_data(new_data: Array) -> void:
	data = new_data
	display_data()


func get_data() -> Array:
	return data
