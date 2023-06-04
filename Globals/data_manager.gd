extends Node

var current_data_sorted_in_rows_string: Array = [] setget set_current_data_sorted_in_rows_string, get_current_data_sorted_in_rows_string
var current_data_sorted_in_columns_string: Array = [] setget set_current_data_sorted_in_columns_string, get_current_data_sorted_in_columns_string


func _ready() -> void:
	Signals.connect("calculation_info_needed", self, "_on_calculation_info_needed")
	
	
func transform_data_in_columns() -> void:
	var column_number: int = current_data_sorted_in_rows_string[1].size()
	prepare_columns(column_number)

	for line in current_data_sorted_in_rows_string:
		for element_index in line.size():
				current_data_sorted_in_columns_string[element_index].append(String(line[element_index]))
	
	

func prepare_columns(column_number) -> void:
	for n in column_number:
		current_data_sorted_in_columns_string.append([])


func _on_calculation_info_needed() -> void:
	Signals.emit_signal("send_sample_data_for_calculation", current_data_sorted_in_columns_string.duplicate(true))


## other scripts call these functions to get data for linear regression

func find_data_column(column_name: String) -> Array:
	var data_column: Array = []
	
	for column in current_data_sorted_in_columns_string:
		if column_name == column[0]:
			data_column.append_array(column)
	return data_column


func find_calibration_curve_values(column_name: String, rows: Array) -> Array:
	var data_column: Array = find_data_column(column_name)
	
	if data_column.empty():
		return []
	
	var cc_values: Array = []
	for row_index in rows:
		if row_index >= 0 and row_index <= data_column.size():
			cc_values.append(float(data_column[row_index]))
	return cc_values


####SETTER GETTER####

func set_current_data_sorted_in_rows_string(new_data: Array) -> void:
	current_data_sorted_in_rows_string = new_data
	Signals.emit_signal("new_data_loaded", current_data_sorted_in_rows_string)
	transform_data_in_columns()


func get_current_data_sorted_in_rows_string() -> Array:
	return current_data_sorted_in_rows_string


func get_current_data_sorted_in_columns_string() -> Array:
	return current_data_sorted_in_columns_string.duplicate(true)


func set_current_data_sorted_in_columns_string( new_data: Array) -> void:
	current_data_sorted_in_columns_string = new_data
	Signals.emit_signal("data_updated")
