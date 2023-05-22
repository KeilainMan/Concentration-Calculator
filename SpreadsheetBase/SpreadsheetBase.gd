extends Control

onready var row_container = $RowContainer

var all_labels: Array = []
var all_rows: Array = []
var all_columns: Array = []
var all_columns_data: Array = []

var label_min_size: Vector2 = Vector2(100,20)



func _ready():
	Signals.connect("data_received", self, "on_receiving_data")
	Signals.connect("calculation_info_needed", self, "on_calculation_info_needed")


func on_receiving_data(data: Array) -> void:
	delete_old_spreadsheet()


	var column_number: int = data[1].size()
	prepare_column_array(column_number)
	
	for line in data:
		insert_line_to_spreadsheet(line)

	DataManager.set_current_data_sorted_in_columns(all_columns_data)
	fancy_layout()


func delete_old_spreadsheet() -> void:
	all_labels.clear()
	all_columns.clear()
	all_columns_data.clear()
	all_rows.clear()
	for child in row_container.get_children():
		child.queue_free()



func prepare_column_array(column_number) -> void:
	for n in column_number:
		all_columns.append([])
		all_columns_data.append([])


func insert_line_to_spreadsheet(line) -> void:
	var line_parent: HBoxContainer = instance_new_line()
	for element_index in line.size():
		var current_label: Label = instance_new_element_label(line_parent, element_index)
		display_value_on_label(current_label, line[element_index])
		all_columns_data[element_index].append(line[element_index])
		
	print(all_columns_data)


func display_value_on_label(current_label, element) -> void:
	current_label.text = str(element)


func instance_new_line() -> HBoxContainer:
	var new_line: HBoxContainer = HBoxContainer.new()
	row_container.add_child(new_line)
	
	all_rows.append(new_line)
	
	return(new_line)


func instance_new_element_label(parent: HBoxContainer, column_index: int) -> Label:
	var new_label = Label.new()
	configure_layout(new_label)
	parent.add_child(new_label)
	
	all_labels.append(new_label)
	all_columns[column_index].append(new_label)
	
	return new_label


func configure_layout(new_label) -> void:
	new_label.rect_min_size = label_min_size
	new_label.align = 2
	new_label.valign = 1
	new_label.size_flags_horizontal = 2
	new_label.size_flags_horizontal = 1
	new_label.clip_text = true


func fancy_layout() -> void:
	#adapt_column_size()
	set_first_column_right()
	
#
#func adapt_column_size() -> void:
#	for column_index in all_columns.size():
#		var biggest_entry_x: int = find_biggest_entry_x(all_columns[column_index])
#		if biggest_entry_x > label_min_size.x:
#			expand_label_size_of_column(all_columns[column_index], biggest_entry_x)
#		#print(biggest_entry_x)
#
#
#func find_biggest_entry_x(column : Array) -> int:
#	#print(column)
#	var biggest_entry_x: int = 0
#	for entry_label in column:
#		print(entry_label, " ", entry_label.rect_size.x)
#		if entry_label.rect_size.x > biggest_entry_x:
#			biggest_entry_x = entry_label.rect_size.x
#			print(biggest_entry_x, entry_label.rect_size.x)
#	return biggest_entry_x
#
#
#func expand_label_size_of_column(column : Array, label_size_x: int) -> void:
#	for entry_label in column:
#		 entry_label.rect_min_size.x = label_size_x


func set_first_column_right() -> void:
	for entry_label in all_columns[0]:
		entry_label.align = 0


func on_calculation_info_needed() -> void:
	Signals.emit_signal("send_sample_data_for_calculation", all_columns_data.duplicate(true))
