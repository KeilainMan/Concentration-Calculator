extends Tabs
class_name CalibrationCurveTab

onready var tab_name_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/TabNameContainer/TabNameEdit
onready var compound_name_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CompoundNameContainer2/CompoundNameEdit
onready var column_name_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/ColumnNameContainer/ColumnNameEdit

onready var curve_concentration_edit_1 = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveConcentrationTable/HBoxContainer/CurveConcentrationEdit1
onready var curve_concentration_edit_2 = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveConcentrationTable2/HBoxContainer/CurveConcentrationEdit2
onready var curve_concentration_edit_3 = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveConcentrationTable3/HBoxContainer/CurveConcentrationEdit3
onready var curve_concentration_edit_4 = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveConcentrationTable4/HBoxContainer/CurveConcentrationEdit4
onready var curve_concentration_edit_5 = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveConcentrationTable5/HBoxContainer/CurveConcentrationEdit5
onready var curve_concentration_edit_6 = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveConcentrationTable6/HBoxContainer/CurveConcentrationEdit6
onready var curve_concentration_edit_7 = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveConcentrationTable7/HBoxContainer/CurveConcentrationEdit7
onready var curve_concentration_edit_8 = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveConcentrationTable8/HBoxContainer/CurveConcentrationEdit8
onready var curve_concentration_edit_9 = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveConcentrationTable9/HBoxContainer/CurveConcentrationEdit9
onready var curve_concentration_edit_10 = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveConcentrationTable10/HBoxContainer/CurveConcentrationEdit10

onready var curve_row_edit_1 = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveConcentrationTable/HBoxContainer/CurveRowEdit1
onready var curve_row_edit_2 = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveConcentrationTable2/HBoxContainer/CurveRowEdit2
onready var curve_row_edit_3 = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveConcentrationTable3/HBoxContainer/CurveRowEdit3
onready var curve_row_edit_4 = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveConcentrationTable4/HBoxContainer/CurveRowEdit4
onready var curve_row_edit_5 = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveConcentrationTable5/HBoxContainer/CurveRowEdit5
onready var curve_row_edit_6 = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveConcentrationTable6/HBoxContainer/CurveRowEdit6
onready var curve_row_edit_7 = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveConcentrationTable7/HBoxContainer/CurveRowEdit7
onready var curve_row_edit_8 = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveConcentrationTable8/HBoxContainer/CurveRowEdit8
onready var curve_row_edit_9 = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveConcentrationTable9/HBoxContainer/CurveRowEdit9
onready var curve_row_edit_10 = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveConcentrationTable10/HBoxContainer/CurveRowEdit10

onready var check_box_1 = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveConcentrationTable/HBoxContainer/CheckBox1
onready var check_box_2 = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveConcentrationTable2/HBoxContainer/CheckBox2
onready var check_box_3 = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveConcentrationTable3/HBoxContainer/CheckBox3
onready var check_box_4 = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveConcentrationTable4/HBoxContainer/CheckBox4
onready var check_box_5 = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveConcentrationTable5/HBoxContainer/CheckBox5
onready var check_box_6 = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveConcentrationTable6/HBoxContainer/CheckBox6
onready var check_box_7 = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveConcentrationTable7/HBoxContainer/CheckBox7
onready var check_box_8 = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveConcentrationTable8/HBoxContainer/CheckBox8
onready var check_box_9 = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveConcentrationTable9/HBoxContainer/CheckBox9
onready var check_box_10 = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveConcentrationTable10/HBoxContainer/CheckBox10

onready var curve_style_button = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveStyleContainer/CurveStyleButton
onready var graph_2d = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CenterContainer/Graph2D


var tab_class: String = "CALIBRATION_CURVE"
var tab_name: String = "" #setget set_tab_name
var compound_name: String = ""
var column_name: String = ""
var concentration_row_count: int = 3
var all_cc_concentration_edits: Array = []#[curve_concentration_edit_1, curve_concentration_edit_2, curve_concentration_edit_3, curve_concentration_edit_4, curve_concentration_edit_5, curve_concentration_edit_6, curve_concentration_edit_7, curve_concentration_edit_8, curve_concentration_edit_9, curve_concentration_edit_10]
var all_cc_row_edits: Array = [] #[curve_row_edit_1, curve_row_edit_2, curve_row_edit_3, curve_row_edit_4, curve_row_edit_5, curve_row_edit_6, curve_row_edit_7, curve_row_edit_8, curve_row_edit_9, curve_row_edit_10]
var all_cc_curve_tick_buttons: Array = []#[check_box_1, check_box_2, check_box_3, check_box_4, check_box_5, check_box_6, check_box_7, check_box_8, check_box_9, check_box_10]
var curve_concentrations: Array = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1] #floats
var curve_rows: Array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] #ints
var curve_ticks: Array = [false, false, false, false, false, false, false, false, false, false]
var curve_style: int = 0

var current_cc_properties: Array = []
var current_x_values: Array = []
var current_y_values: Array = []

var all_plot_ids: Array = []

var tab_properties: Array = [
	tab_class,
	tab_name,
	compound_name,
	column_name,
	curve_concentrations,
	curve_rows,
	curve_ticks,
	curve_style
] setget set_tab_properties, get_tab_properties

enum curve_styles {
	ORIGIN_INTERCEPT,
	INTERCEPT,
}



var curve_styles_labels: Array = [
	"origin intercept",
	"intercept"
]

func _ready():
	Signals.connect("calculation_info_needed", self, "on_calculation_info_needed")
	Signals.connect("data_updated", self, "_on_data_updated")
	
	add_items_for_curve_style_button()
	prepare_cc_table_array()


func prepare_cc_table_array() -> void:
	all_cc_concentration_edits.append_array([curve_concentration_edit_1, curve_concentration_edit_2, curve_concentration_edit_3, curve_concentration_edit_4, curve_concentration_edit_5, curve_concentration_edit_6, curve_concentration_edit_7, curve_concentration_edit_8, curve_concentration_edit_9, curve_concentration_edit_10])
	all_cc_row_edits.append_array([curve_row_edit_1, curve_row_edit_2, curve_row_edit_3, curve_row_edit_4, curve_row_edit_5, curve_row_edit_6, curve_row_edit_7, curve_row_edit_8, curve_row_edit_9, curve_row_edit_10])
	all_cc_curve_tick_buttons.append_array([check_box_1, check_box_2, check_box_3, check_box_4, check_box_5, check_box_6, check_box_7, check_box_8, check_box_9, check_box_10])


## UI APPEARANCE FUNCTIONS ##

func add_items_for_curve_style_button() -> void:
	var index: int = 0
	for item in curve_styles.keys():
		curve_style_button.add_item(curve_styles_labels[index], curve_styles.get(item))
		index += 1


func _on_TabNameEdit_text_changed(new_text):
	tab_name = new_text
	name = new_text
	tab_properties[1] = new_text
	_on_stat_changed()


func _on_CompoundNameEdit_text_changed(new_text):
	compound_name = new_text
	tab_properties[2] = new_text
	_on_stat_changed()


func _on_ColumnNameEdit_text_changed(new_text):
	column_name = new_text
	tab_properties[3] = new_text
	_on_stat_changed()


func _on_CurveStyleButton_item_selected(index):
	curve_style = index
	tab_properties[6] = curve_style
	_update_graph()
	print("New Curve Style selected")
	_on_stat_changed()


func set_up_values() -> void:
	if tab_properties.size() == 8:
		tab_name = tab_properties[1]
		compound_name = tab_properties[2]
		column_name = tab_properties[3]
		curve_concentrations = tab_properties[4]
		curve_rows = tab_properties[5]
		curve_ticks = tab_properties[6]
		curve_style = tab_properties[7]


func update_line_edits() -> void:
	tab_name_edit.text = tab_name
	name = tab_name
	compound_name_edit.text = compound_name
	column_name_edit.text = column_name
	curve_style_button._select_int(curve_style)
	_update_cc_table()
	_update_graph()
	_on_stat_changed()


func _update_cc_table() -> void:
	for index in all_cc_concentration_edits.size():
		all_cc_concentration_edits[index].text = String(curve_concentrations[index])
		all_cc_row_edits[index].text = String(curve_rows[index])
		all_cc_curve_tick_buttons[index].pressed = curve_ticks[index]


func on_calculation_info_needed() -> void:
	var values: Array = gather_valid_x_and_y_values()
	Signals.emit_signal("send_cc_data_for_calculation", [tab_class, column_name, values[0], values[1], curve_style])

########################################

func _update_graph() -> void:
	current_cc_properties.clear()
	for id in all_plot_ids:
		graph_2d.remove_curve(id)
	
	var values: Array = gather_valid_x_and_y_values()
	print(values)
	var x_axis_values: Array = values[0]
	var y_axis_values: Array = values[1]

	var lr_parameters: Array = []
	var curve_label: String

	if x_axis_values.size() > 2 and y_axis_values.size() > 2:
		lr_parameters.append_array(LinearRegressionCalculator.perform_linear_regression(x_axis_values, y_axis_values, curve_style))
		current_cc_properties.append_array(lr_parameters)
		if lr_parameters.empty():
			print("No LR happened")
			return
		if curve_style == curve_styles.INTERCEPT:
			curve_label = "y = " + str(lr_parameters[0]) + "x " + str(lr_parameters[1]) + ", R^2: " + str(lr_parameters[2])
		else:
			curve_label = "y = " + str(lr_parameters[0]) + "x, R^2: " + str(lr_parameters[2])

		var plot_id = graph_2d.add_curve(curve_label, Color.azure, 1.0)
		for x in range(0,x_axis_values.max(),x_axis_values.max()/50):
			var y1: float = lr_parameters[0] * x
			graph_2d.add_point(plot_id, Vector2(x, y1))

		var scatter_plot_id: int = graph_2d.add_curve("", Color.orange, 3, true)
		for x_index in x_axis_values.size():
			graph_2d.add_point(scatter_plot_id, Vector2(x_axis_values[x_index], y_axis_values[x_index]))
		
		all_plot_ids.append(plot_id)
		all_plot_ids.append(scatter_plot_id)

		graph_2d.set_y_axis_max_value(y_axis_values.max())
		graph_2d.set_y_axis_label("Concentration in ng/ml")
		graph_2d.set_x_axis_max_value(x_axis_values.max())
		graph_2d.set_x_axis_label("Area")
	
	_on_stat_changed()


func gather_valid_x_and_y_values() -> Array:
	current_x_values.clear()
	current_y_values.clear()
	
	
	var x_value_rows: Array = []
	var y_values: Array = []
	
	for index in curve_ticks.size():
		if curve_ticks[index]:
			x_value_rows.append(curve_rows[index])
			y_values.append(curve_concentrations[index])
	var x_values: Array = DataManager.find_calibration_curve_values(column_name, x_value_rows)
	var values: Array = []
	
	current_x_values = x_values
	current_y_values = y_values
	
	values.append(x_values)
	values.append(y_values)
	
	return values


func _on_data_updated() -> void:
	print("data updated")
	_update_graph()


#########################################
################################################################################
## Summary Functions ##

func _on_stat_changed() -> void:
	var curve_values: Array = []
	var cs: String = ""
	for index in current_x_values.size():
		curve_values.append("( " + String(current_x_values[index]) + " , " + String(current_y_values[index]) + " )")

	var summary_stats: Array = [
		tab_name,
		compound_name,
		column_name,
		current_cc_properties,
		curve_values]
	SummaryManager.update_cc_summary(summary_stats)


################################################################################
##  ##

func set_tab_properties(new_properties: Array) -> void:
	tab_properties = new_properties
	set_up_values()
	update_line_edits()


func get_tab_properties() -> Array:
	return tab_properties


## Concentration Table Functions ##################

func _on_cc_table_changed() -> void:
	tab_properties[4] = curve_concentrations
	tab_properties[5] = curve_rows
	tab_properties[6] = curve_ticks
	_update_graph()


func _on_CurveConcentrationEdit1_text_changed(new_text: String) -> void:
	curve_concentrations[0] = float(new_text)
	_on_cc_table_changed()

func _on_CurveRowEdit1_text_changed(new_text: String) -> void:
	curve_rows[0] = int(new_text)
	_on_cc_table_changed()

func _on_CurveConcentrationEdit2_text_changed(new_text: String) -> void:
	curve_concentrations[1] = float(new_text)
	_on_cc_table_changed()

func _on_CurveRowEdit2_text_changed(new_text: String) -> void:
	curve_rows[1] = int(new_text)
	_on_cc_table_changed()

func _on_CurveConcentrationEdit3_text_changed(new_text: String) -> void:
	curve_concentrations[2] = float(new_text)
	_on_cc_table_changed()

func _on_CurveRowEdit3_text_changed(new_text: String) -> void:
	curve_rows[2] = int(new_text)
	_on_cc_table_changed()

func _on_CurveConcentrationEdit4_text_changed(new_text: String) -> void:
	curve_concentrations[3] = float(new_text)
	_on_cc_table_changed()

func _on_CurveRowEdit4_text_changed(new_text: String) -> void:
	curve_rows[3] = int(new_text)
	_on_cc_table_changed()

func _on_CurveConcentrationEdit5_text_changed(new_text: String) -> void:
	curve_concentrations[4] = float(new_text)
	_on_cc_table_changed()

func _on_CurveRowEdit5_text_changed(new_text: String) -> void:
	curve_rows[4] = int(new_text)
	_on_cc_table_changed()

func _on_CurveConcentrationEdit6_text_changed(new_text: String) -> void:
	curve_concentrations[5] = float(new_text)
	_on_cc_table_changed()

func _on_CurveRowEdit6_text_changed(new_text: String) -> void:
	curve_rows[5] = int(new_text)
	_on_cc_table_changed()

func _on_CurveConcentrationEdit7_text_changed(new_text: String) -> void:
	curve_concentrations[6] = float(new_text)
	_on_cc_table_changed()

func _on_CurveRowEdit7_text_changed(new_text: String) -> void:
	curve_rows[6] = int(new_text)
	_on_cc_table_changed()

func _on_CurveConcentrationEdit8_text_changed(new_text: String) -> void:
	curve_concentrations[7] = float(new_text)
	_on_cc_table_changed()

func _on_CurveRowEdit8_text_changed(new_text: String) -> void:
	curve_rows[7] = int(new_text)
	_on_cc_table_changed()

func _on_CurveConcentrationEdit9_text_changed(new_text: String) -> void:
	curve_concentrations[8] = float(new_text)
	_on_cc_table_changed()

func _on_CurveRowEdit9_text_changed(new_text: String) -> void:
	curve_rows[8] = int(new_text)
	_on_cc_table_changed()

func _on_CurveConcentrationEdit10_text_changed(new_text: String) -> void:
	curve_concentrations[9] = float(new_text)
	_on_cc_table_changed()

func _on_CurveRowEdit10_text_changed(new_text: String) -> void:
	curve_rows[9] = int(new_text)
	_on_cc_table_changed()

func _on_CheckBox1_pressed() -> void:
	print(check_box_1, check_box_1.pressed)
	curve_ticks[0] = check_box_1.pressed
	_on_cc_table_changed()

func _on_CheckBox2_pressed() -> void:
	curve_ticks[1] = check_box_2.pressed
	_on_cc_table_changed()

func _on_CheckBox3_pressed() -> void:
	curve_ticks[2] = check_box_3.pressed
	_on_cc_table_changed()

func _on_CheckBox4_pressed() -> void:
	curve_ticks[3] = check_box_4.pressed
	_on_cc_table_changed()

func _on_CheckBox5_pressed() -> void:
	curve_ticks[4] = check_box_5.pressed
	_on_cc_table_changed()

func _on_CheckBox6_pressed() -> void:
	curve_ticks[5] = check_box_6.pressed
	_on_cc_table_changed()

func _on_CheckBox7_pressed() -> void:
	curve_ticks[6] = check_box_7.pressed
	_on_cc_table_changed()

func _on_CheckBox8_pressed() -> void:
	curve_ticks[7] = check_box_8.pressed
	_on_cc_table_changed()

func _on_CheckBox9_pressed() -> void:
	curve_ticks[8] = check_box_9.pressed
	_on_cc_table_changed()

func _on_CheckBox10_pressed() -> void:
	curve_ticks[9] = check_box_10.pressed
	_on_cc_table_changed()
