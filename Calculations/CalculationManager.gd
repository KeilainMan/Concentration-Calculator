extends Node


var sample_data: Array = [] #Array contains Arrays of columns
var sheet_names: Array = []
var general_info: Array = [] #varying_extraction_volumes, extraction_volume, extraction_volume_column_name,
							#normalization, masses_column_name, input_mode, sample_name_column,
							#sample_name_sheet_name, sample_area_column, internal_standard_area_column, header]
var is_info: Array = [] #Array contains Arrays with structure: tab_class, column_name, is_concentration, response_factor
var cc_info: Array = [] #Array contains Arrays with structure: tab_class, column_name, x_values, y_values, curve_style
var results: Array = []


func _ready():
	Signals.connect("path_for_calculation_selected", self, "on_path_for_calculation_selected")
	Signals.connect("send_sample_data_for_calculation", self, "_on_sample_data_for_calculation_received")
	Signals.connect("send_general_data_for_calculation", self, "_on_general_data_for_calculation_received")
	Signals.connect("send_is_data_for_calculation", self, "_on_is_data_for_calculation_received")
	Signals.connect("send_cc_data_for_calculation", self, "_on_cc_data_for_calculation_received")
	

#########################################################################
## Starts calculation process ##
func on_path_for_calculation_selected(save_file_path: String) -> void:
	print("Start calculation")
	start_calculation_process(save_file_path)
	


func start_calculation_process(save_file_path: String) -> void:
	Signals.emit_signal("calculation_info_needed")
	print("In need for Information")
	print("calculating...")
	
	
	
	if !check_if_calculation_is_allowed():
		PopUpManager.show_popup(0)
		return
		
	var results: Array = []
	
	#checks if user has varying extraction volumes
	var extraction_volume_column: Array = []
	if general_info[0] == 0:
		extraction_volume_column = find_specific_column_for_calculation(general_info[2])
		print(extraction_volume_column)
	#checks if user wants to normalize the data by mass
	var masses_column: Array
	if general_info[3] == 0:
		masses_column = find_specific_column_for_calculation(general_info[4])
	#check for input mode, if input mode 1 (0) the columns will be identified by column name
	#if input mode 2 (1), compounds will be identified by sheets and columns by provided numbers
	#if general_info[5] == 0:
	
	for compound_array in is_info:
		print("start calculation for this compound: ", [compound_array])
		var result_column: Array = calculate_internal_standard_result_column(compound_array, extraction_volume_column, masses_column)
		results.append(result_column)
	
	for compound_array in cc_info:
		var result_column: Array = calculate_calibration_curve_result_column(compound_array, extraction_volume_column, masses_column)
		results.append(result_column)
	
	#inserts sample names
	if general_info[5] == 0:
		results.insert(0, sample_data[0][general_info[6] - 1])
	else:
		var sheet_index: int = sheet_names.find(general_info[7])
		results.insert(0, sample_data[sheet_index][general_info[6] - 1])
	
	
	var results_transposed: Array = transpose_results(results)
	save_file(save_file_path, results_transposed)
#	Signals.emit_signal("calculation_completed")
	clear_data()


func check_if_calculation_is_allowed() -> bool:
	if sample_data.empty() or general_info.empty() or (is_info.size() + cc_info.size()) < 1:
		return false
	else:
		return true


func transpose_results(result: Array) -> Array:
	var trestults: Array = []
	for row_index in result[0].size():
		var line: PoolStringArray = []
		for column in result:
			if !column.empty():
				line.append(String(column[row_index]))
		trestults.append(line)
	return trestults


func find_specific_column_for_calculation(column_name: String, is_flag: bool = false) -> Array:
	var column: Array = []
	#checks input mode, if columns or sheets are present (with columns, header is alsways true)
	if general_info[5] == 0:
		for col in sample_data[0]:
			if col[0] == column_name:
				if is_flag:
					var col_index = sample_data[0].find(col)
					column.append_array(sample_data[0][col_index + 1])
					column.pop_front()
				else:
					column.append_array(col)
					column.pop_front()
	else:
		var sheet_index: int = sheet_names.find(column_name)
		if sheet_index == -1:
			return column
		elif sheet_index <= sample_data.size():
			var current_sheet: Array = sample_data[sheet_index]
			if column_name == general_info[2] or column_name == general_info[4]:
				column.append_array(current_sheet[0])
			elif is_flag:
				if general_info[9] - 1 <= current_sheet.size():
					column.append_array(current_sheet[general_info[9] - 1])
				else: return column
			else:
				if general_info[8] - 1 <= current_sheet.size():
					column.append_array(current_sheet[general_info[8]-1])
				else: return column
			if general_info[10] == 0:
						column.pop_front()
	return column


func calculate_internal_standard_result_column(compound_array: Array, extraction_volume_column: Array, masses_column: Array) -> Array:
	var result_column: Array = []
	var is_data: Array = [compound_array[2], compound_array[3]]
	var is_column: Array = find_specific_column_for_calculation(compound_array[1], true)
	var compound_column: Array = find_specific_column_for_calculation(compound_array[1])
	#print("compound column size: ", compound_column.size())
	if compound_column.empty() or is_column.empty():
		return result_column
		
	result_column = perform_internal_standard_compound_calculation(compound_column, is_column,  extraction_volume_column, masses_column, is_data)
	result_column.insert(0, compound_array[1])
	#print("result_column: ", result_column)
	return result_column


func calculate_calibration_curve_result_column(compound_array: Array, extraction_volume_column: Array, masses_column: Array) -> Array:
	var result_column: Array = []
	var compound_column: Array = find_specific_column_for_calculation(compound_array[1])
	var curve_properties: Array = LinearRegressionCalculator.perform_linear_regression(compound_array[2], compound_array[3], compound_array[4])
	if compound_column.empty() or curve_properties.empty():
		return result_column
		
	result_column = perform_calibration_curve_compound_calculation(compound_column, extraction_volume_column, masses_column, curve_properties[0])
	result_column.insert(0, compound_array[1])
	return result_column


## IS-Calculation ###################################################

func perform_internal_standard_compound_calculation(compound_column: Array, is_column: Array,  extraction_volume_column: Array, masses_column: Array, is_data: Array) -> Array:
	var result_column: Array = []
	print(compound_column.size(), " ",  is_column.size())
	if compound_column.size() == is_column.size():
		for entry_index in compound_column.size():
			print("entry: ", entry_index)
			var area_proportion: float = calculate_area_proportion(float(compound_column[entry_index]), float(is_column[entry_index]))
			var result_without_normalization: float = 0.0
			if general_info[0] == 0:
				if compound_column.size() <= extraction_volume_column.size():
					result_without_normalization = calculate_internal_standard_method_raw_value(area_proportion, float(extraction_volume_column[entry_index]), is_data[0], is_data[1])
				else:
					return result_column
			else: 
				result_without_normalization = calculate_internal_standard_method_raw_value(area_proportion, general_info[1], is_data[0], is_data[1])
			if general_info[3] == 0:
				if compound_column.size() <= masses_column.size():
					var result_normalized: float = calculate_normalized_value_from_raw_value(result_without_normalization, float(masses_column[entry_index]))
					result_column.append(result_normalized)
				else:
					return result_column
			else:
				result_column.append(result_without_normalization)
			print(result_column)
	return result_column


func calculate_area_proportion(compound_area: float, is_area: float) -> float:
	print("areas: ", compound_area, " ", is_area)
	if is_area == 0:
		return 0.0
	else:
		var result: float = compound_area/is_area
		return result


func calculate_internal_standard_method_raw_value(area_proportion: float, extraction_volume: float, is_conc: float, rep_factor: float) -> float:
	var result: float = area_proportion * extraction_volume * is_conc * rep_factor
	return result 


func calculate_normalized_value_from_raw_value(raw_value: float, mass: float) -> float:
	var result: float = (raw_value/mass)*1000 #result in ng/g
	return result


#####################################################################

func perform_calibration_curve_compound_calculation(compound_column: Array, extraction_volume_column: Array, masses_column: Array, slope: float) -> Array:
	var result_column: Array = []
	
	for entry_index in compound_column.size():
		var result_without_normalization: float = 0.0
		if general_info[0] == 0:
			if compound_column.size() <= extraction_volume_column.size():
				result_without_normalization = calculate_calibration_curve_method_raw_value(float(compound_column[entry_index]), float(extraction_volume_column[entry_index]), slope)
			else:
				return result_column
		else:
			result_without_normalization = calculate_calibration_curve_method_raw_value(float(compound_column[entry_index]), general_info[1], slope)
		if general_info[3] == 0:
			if compound_column.size() <= masses_column.size():
				var result_normalized: float = calculate_normalized_value_from_raw_value(result_without_normalization, float(masses_column[entry_index]))
				result_column.append(result_normalized)
			else:
				return result_column
		else:
			result_column.append(result_without_normalization)
	return result_column


func calculate_calibration_curve_method_raw_value(compound_area: float, extraction_volume: float, slope: float) -> float:
	var result: float = compound_area * extraction_volume * slope
	return result 


func calc_compound_concentrations_cc(compound_data, masses_column, slope) -> Array:
	var all_results: Array = []
	
	for entry_index in compound_data.size():
		var result_in_ng: float = float(compound_data[entry_index]) * (slope) * float(general_info[0])
		var result_in_ng_pro_g: float = (result_in_ng/float(masses_column[entry_index]))*1000
		all_results.append(result_in_ng_pro_g)
	return all_results


#####################################################################

func save_file(save_file_path: String, result: Array) -> void:
	var new_file = File.new()
	new_file.open(save_file_path, File.WRITE)
	
	for line in result:
		new_file.store_csv_line(line, "	")
	
	new_file.close()


func clear_data() -> void:
	sample_data.clear()
	general_info.clear()
	is_info.clear()
	cc_info.clear()
	results.clear()


#####################################################################

func _on_sample_data_for_calculation_received(new_sample_data: Array, new_sheet_names: Array) -> void:
	sample_data = new_sample_data
	sheet_names = new_sheet_names
	print("sample data received")


func _on_general_data_for_calculation_received(new_general_data: Array) -> void:
	general_info = new_general_data
	print("general data received")


func _on_is_data_for_calculation_received(new_is_data: Array) -> void:
	is_info.append(new_is_data)
	print("internal standard data received")


func _on_cc_data_for_calculation_received(new_cc_data: Array) -> void:
	cc_info.append(new_cc_data)
	print("calibration curve data received")

