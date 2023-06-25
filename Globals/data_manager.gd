extends Node

var file_path: String = "" setget set_file_path, get_file_path

var current_data_sorted_in_rows_string: Array = [] setget set_current_data_sorted_in_rows_string, get_current_data_sorted_in_rows_string
var current_data_sorted_in_columns_string: Array = [] setget , get_current_data_sorted_in_columns_string#set_current_data_sorted_in_columns_string, get_current_data_sorted_in_columns_string
var sheet_names: Array = ["Sheet1"] setget set_sheet_names, get_sheet_names


var current_importfile: int = importfile.TXT
var sample_area_column_number: int = 1
enum importfile {
	TXT,
	XLSX,
}


func _ready() -> void:
	Signals.connect("calculation_info_needed", self, "_on_calculation_info_needed")
	Signals.connect("sample_area_column_changed", self, "_on_sample_area_column_changed")


func _on_new_file_name_set() -> void:
	clear_current_data()
	
	if file_path.ends_with(".txt"):
		current_importfile = importfile.TXT
		var file_content_in_rows: Array = _import_text_file()
		set_current_data_sorted_in_rows_string(file_content_in_rows)
	elif file_path.ends_with(".xlsx"):
		current_importfile = importfile.XLSX
		var file_content_in_rows: Array = DataPorter.ImportWorkbook(file_path)
		var file_sheet_names: Array = DataPorter.GetSheetNames(file_path)
		set_sheet_names(file_sheet_names) 
		set_current_data_sorted_in_rows_string(file_content_in_rows)


func _import_text_file() -> Array:
	var file: File = File.new()
	file.open(file_path, File.READ)
	
	var file_content: Array = []
	file_content.append([])
	while file.get_position() < file.get_len():
		var content = file.get_csv_line("	")
		file_content[0].append(content)
		
	file.close()
	
	return file_content


func transform_data_in_columns() -> void:
	for sheet_index in current_data_sorted_in_rows_string.size():
		var column_count: int = current_data_sorted_in_rows_string[sheet_index][0].size()
		var sheet_array: Array = prepare_columns(column_count)

		for row in current_data_sorted_in_rows_string[sheet_index]:
			for column_index in row.size():
				sheet_array[column_index].append(String(row[column_index]))
		current_data_sorted_in_columns_string.append(sheet_array)
	print("sending data uploaded signal")
	Signals.emit_signal("data_updated")


func prepare_columns(column_count: int) -> Array:
	var sheet_array: Array = []
	for n in column_count:
		sheet_array.append([])
		#current_data_sorted_in_columns_string[sheet_index].append([])
	return sheet_array


func _on_calculation_info_needed() -> void:
	Signals.emit_signal("send_sample_data_for_calculation", current_data_sorted_in_columns_string.duplicate(true), sheet_names.duplicate(true))


func _on_sample_area_column_changed(new_number: int) -> void:
	sample_area_column_number = clamp(new_number - 1, 0.0, 1000.0)


func clear_current_data() -> void:
	current_data_sorted_in_rows_string.clear()
	current_data_sorted_in_columns_string.clear()
	sheet_names.clear()


## other scripts call these functions to get data for linear regression

func find_data_column(column_name: String) -> Array:
	var data_column: Array = []
	
	match current_importfile:
		importfile.TXT:
			if !current_data_sorted_in_columns_string.empty():
				for col in current_data_sorted_in_columns_string[0]:
					if column_name == col[0]:
						data_column.append_array(col)
		importfile.XLSX:
			var sheet_index: int = sheet_names.find(column_name)
			if sheet_index == - 1:
				return data_column
			elif sheet_index <= current_data_sorted_in_columns_string.size():
				var sheet: Array = current_data_sorted_in_columns_string[sheet_index]
				if sample_area_column_number <= sheet.size():
					data_column.append_array(sheet[sample_area_column_number])
			else:
				return data_column
	
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

func set_file_path(new_path: String) -> void:
	file_path = new_path
	_on_new_file_name_set()


func get_file_path() -> String:
	return file_path


func set_current_data_sorted_in_rows_string(new_data: Array) -> void:
	current_data_sorted_in_rows_string = new_data
	Signals.emit_signal("new_data_loaded", current_data_sorted_in_rows_string, sheet_names)
	transform_data_in_columns()


func get_current_data_sorted_in_rows_string() -> Array:
	return current_data_sorted_in_rows_string


func get_current_data_sorted_in_columns_string() -> Array:
	return current_data_sorted_in_columns_string.duplicate(true)


#func set_current_data_sorted_in_columns_string( new_data: Array) -> void:
#	current_data_sorted_in_columns_string = new_data
#	Signals.emit_signal("data_updated")


func set_sheet_names(new_names: Array) -> void:
	sheet_names = new_names


func get_sheet_names() -> Array:
	return sheet_names
