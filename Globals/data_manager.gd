extends Node


var current_data_sorted_in_columns: Array = [] setget set_current_data_sorted_in_columns, get_current_data_sorted_in_columns



func find_data_column(column_name: String) -> Array:
	var data_column: Array = []
	
	for column in current_data_sorted_in_columns:
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


func set_current_data_sorted_in_columns( new_data: Array) -> void:
	current_data_sorted_in_columns = new_data
	Signals.emit_signal("data_updated")


func get_current_data_sorted_in_columns() -> Array:
	return current_data_sorted_in_columns.duplicate(true)
