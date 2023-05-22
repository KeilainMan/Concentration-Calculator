extends Node


var sample_data: Array = [] #Array contains Arrays of columns
var general_data: Array = [] #extraction_volume, masses_column_name, column_selection
var is_data: Array = [] #Array contains Arrays with structure: tab_class, column_name, is_concentration, response_factor
var cc_data: Array = [] #Array contains Arrays with structure: tab_class, column_name, curve_concentrations, curve_rows, curve_style
var results: Array = []


func _ready():
	Signals.connect("path_for_calculation_selected", self, "on_path_for_calculation_selected")
	Signals.connect("send_sample_data_for_calculation", self, "_on_sample_data_for_calculation_received")
	Signals.connect("send_general_data_for_calculation", self, "_on_general_data_for_calculation_received")
	Signals.connect("send_is_data_for_calculation", self, "_on_is_data_for_calculation_received")
	Signals.connect("send_cc_data_for_calculation", self, "_on_cc_data_for_calculation_received")
	
	
func on_path_for_calculation_selected(save_file_path: String) -> void:
	print("Start calculation")
	start_calculation_process(save_file_path)
	


func start_calculation_process(save_file_path: String) -> void:
	Signals.emit_signal("calculation_info_needed")
	print("In need for Information")
	#yield(get_tree().create_timer(0.15), "timeout")
	
	print("calculating...")
	var masses_column: Array = find_masses_column()
	
	for compound_array in is_data:
		var is_data: Array = [compound_array[2], compound_array[3]]
		var compound_data: Array = find_compound_and_is_column(compound_array[1], true)
		if compound_data.empty():
			continue
		var compound_calculation_results: Array = calc_compound_concentrations_is(compound_data, masses_column, is_data)
		compound_calculation_results.insert(0, compound_array[1])
		results.append(compound_calculation_results)
	
	for compound_array in cc_data:
		var compound_data: Array = find_compound_and_is_column(compound_array[1], false)
		var curve_data: Array = prepare_cc_calculation(compound_array[2], compound_array[3], compound_data[0])
		var curve_properties: Array = LinearRegressionCalculator.perform_linear_regression(curve_data[1], curve_data[0], compound_array[4])
		if compound_data.empty() or curve_properties.empty():
			continue
		var compound_calculation_results: Array = calc_compound_concentrations_cc(compound_data[0], masses_column, curve_properties[0])
		compound_calculation_results.insert(0, compound_array[1])
		results.append(compound_calculation_results)
		
	results.insert(0, sample_data[0])
	var results_transposed: Array = transpose_results(results)
	save_file(save_file_path, results_transposed)
#	Signals.emit_signal("calculation_completed")
	clear_data()


func transpose_results(result: Array) -> Array:
	var trestults: Array = []
	for row_index in result[0].size():
		var line: PoolStringArray = []
		for column in result:
			line.append(String(column[row_index]))
		trestults.append(line)
	return trestults


func find_masses_column() -> Array:
	var mass_column: Array = []
	for column in sample_data:
		#print("column: ", column[0], " column name: ", general_data[1])
		if column[0] == general_data[1]:
			mass_column.append_array(column)
			mass_column.pop_front()
			return mass_column
		else:
			pass
			#print("could not find mass column/or not provided")
	return mass_column




## IS-Calculation ###################################################

func find_compound_and_is_column(sample_compound_column_name: String, is_column_flag: bool) -> Array:
	var compound_and_is_column: Array = []
	
	for compound_column_index in sample_data.size():
		if sample_data[compound_column_index][0] == sample_compound_column_name:
			compound_and_is_column.append(sample_data[compound_column_index])
			if general_data[2] == 0 and is_column_flag:
				compound_and_is_column.append(sample_data[compound_column_index + 1])
			else:
				pass	
		else:
			pass
			#print("Column: ", sample_compound_column_name, "not found!")
	for column in compound_and_is_column:
		column.pop_front()
	return compound_and_is_column


func calc_compound_concentrations_is(compound_data: Array, masses_column: Array, is_data: Array) -> Array:
	var all_results: Array = []
	for entry in compound_data[0].size():
		var single_result: float = calc_single_entry_is(float(compound_data[0][entry]), \
		float(compound_data[1][entry]), \
		float(masses_column[entry]), \
		float(general_data[0]), \
		float(is_data[0]), \
		float(is_data[1]))
		all_results.append(single_result)
	return all_results


func calc_single_entry_is(sample_area: float, is_area: float, mass: float, ext_vol: float, is_conc: float, rep_f: float) -> float:
	if is_area == 0:
		return 0.0
	
	var result_ng: float = (sample_area/is_area) * is_conc * ext_vol * rep_f
	var result_ng_pro_g: float = (result_ng/mass)*1000
	return result_ng_pro_g
#####################################################################

func prepare_cc_calculation(known_concs: Array, rows: Array, compound_data: Array) -> Array:
	var curve_data: Array = []
	curve_data.append(known_concs)
	
	var areas: Array = []
	for row in rows:
		areas.append(float(compound_data[row-1]))
	curve_data.append(areas)
	print(curve_data)
	return curve_data


func calc_compound_concentrations_cc(compound_data, masses_column, slope) -> Array:
	var all_results: Array = []
	
	for entry_index in compound_data.size():
		var result_in_ng: float = float(compound_data[entry_index]) * (slope) * float(general_data[0])
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
	general_data.clear()
	is_data.clear()
	cc_data.clear()
	results.clear()


#####################################################################

func _on_sample_data_for_calculation_received(new_sample_data: Array) -> void:
	sample_data = new_sample_data
	print("sample data received")


func _on_general_data_for_calculation_received(new_general_data: Array) -> void:
	general_data = new_general_data
	print("general data received")


func _on_is_data_for_calculation_received(new_is_data: Array) -> void:
	is_data.append(new_is_data)
	print("internal standard data received")


func _on_cc_data_for_calculation_received(new_cc_data: Array) -> void:
	cc_data.append(new_cc_data)
	print("calibration curve data received")

